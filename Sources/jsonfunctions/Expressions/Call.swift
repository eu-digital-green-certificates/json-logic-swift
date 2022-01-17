//
// json-functions-swift
//

import Foundation
import JSON

struct Call: Expression {

    let functionNameJSON: JSON
    let parametersJSON: JSON?

    let registeredFunctions: [String: JsonFunctionDefinition]

    func eval(with data: inout JSON) throws -> JSON {
        guard let functionName = functionNameJSON.string else {
            throw ParseError.InvalidParameters("Call: Function name must be a string")
        }

        guard let functionDefinition = registeredFunctions[functionName] else {
            throw ParseError.InvalidParameters("Call: No such function")
        }

        let parametersDictionary: [String: JSON]
        if let parametersJSON = parametersJSON {
            if case .Dictionary(let dict) = parametersJSON {
                parametersDictionary = dict
            } else if case .Null = parametersJSON {
                parametersDictionary = [:]
            } else {
                throw ParseError.InvalidParameters("Call: Parameters must be dictionary or null")
            }
        } else {
            parametersDictionary = [:]
        }

        let data = try functionDefinition.parameters.reduce(into: [String: JSON]()) {
            if let parameterValue = parametersDictionary[$1.name] {
                $0[$1.name] = try Parser(
                        json: parameterValue,
                        registeredFunctions: registeredFunctions
                    )
                    .parse()
                    .eval(with: &data)
            } else {
                $0[$1.name] = JSON($1.`default`?.value as Any)
            }
        }

        guard let logicArray = functionDefinition.logic.value as? Array<Any> else {
            throw ParseError.InvalidParameters("Logic in function definition must be array")
        }

        let logicExpressions = try Parser(json: JSON(logicArray)).parse()

        let scriptExpressions: [Expression]
        if let arrayOfExpressions = logicExpressions as? ArrayOfExpressions {
            scriptExpressions = arrayOfExpressions.expressions
        } else {
            throw ParseError.InvalidParameters("Call: Function definition logic must be array")
        }

        return try Script(expressions: scriptExpressions).eval(with: JSON(data))
    }

}
