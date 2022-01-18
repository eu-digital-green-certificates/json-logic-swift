//
// json-functions-swift
//

import Foundation
import JSON

struct Init: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let arrayExpression = expression as? ArrayOfExpressions,
              let firstResult = try arrayExpression.expressions.first?.eval(with: &data)
        else {
            throw ParseError.InvalidParameters("Init: Expected at least one parameter")
        }

        let expressions = Array(arrayExpression.expressions.dropFirst())

        switch firstResult.string {
        case "literal":
            return try evalLiteral(expressions: expressions, with: &data)
        case "object":
            return try evalDictionary(expressions: expressions, with: &data)
        case "array":
            return try evalArray(expressions: expressions, with: &data)
        default:
            throw ParseError.InvalidParameters("Init: Unsupported type")
        }
    }

    func evalLiteral(expressions: [Expression], with data: inout JSON) throws -> JSON {
        guard let result = try expressions.first?.eval(with: &data) else {
            throw ParseError.InvalidParameters("Init: Expected at least two parameters, got only one")
        }

        guard result.array == nil, result.dictionary == nil else {
            throw ParseError.InvalidParameters("Init: Expected literal value")
        }

        return result
    }

    func evalDictionary(expressions: [Expression], with data: inout JSON) throws -> JSON {
        var targetDictionary = [String: JSON]()

        var i = 0
        while i < expressions.count {
            let result = try expressions[i].eval(with: &data)

            if expressions[i] is Spread {
                if let resultDictionary = result.dictionary {
                    resultDictionary.forEach {
                        targetDictionary[$0] = $1
                    }
                } else if let resultArray = result.array {
                    resultArray.enumerated().forEach {
                        targetDictionary[String($0)] = $1
                    }
                } else if result !== .Null {
                    throw ParseError.InvalidParameters("Init: Expected dictionary, array or null")
                }

                i += 1
            } else {
                let key = try result.keyDescription()

                guard let valueResult = try expressions[safe: i + 1]?.eval(with: &data) else {
                    throw ParseError.InvalidParameters("Init: No value for key \"\(key)\"")
                }

                targetDictionary[key] = valueResult

                i += 2
            }
        }

        return JSON(targetDictionary)
    }

    func evalArray(expressions: [Expression], with data: inout JSON) throws -> JSON {
        var targetArray = [JSON]()

        for expression in expressions {
            let result = try expression.eval(with: &data)

            if expression is Spread {
                guard let resultArray = result.array else {
                    throw ParseError.InvalidParameters("Init: Expected array")
                }

                targetArray.append(contentsOf: resultArray)
            } else {
                targetArray.append(result)
            }
        }

        return JSON(targetArray)
    }

}

private extension JSON {

    func keyDescription() throws -> String {
        switch self {
        case .Null:
            throw ParseError.InvalidParameters("Init: Can't use null as key")
        case .Array:
            throw ParseError.InvalidParameters("Init: Can't use array as key")
        case .Dictionary:
            throw ParseError.InvalidParameters("Init: Can't use dictionary as key")
        case .Int(let int64):
            return "\(int64)"
        case .Double(let double):
            return "\(double)"
        case .String(let string):
            return string
        case .Date:
            throw ParseError.InvalidParameters("Init: Can't use date as key")
        case .Bool(let bool):
            return bool ? "true" : "false"
        case .Error(let jSON2Error):
            throw jSON2Error
        }
    }

}
