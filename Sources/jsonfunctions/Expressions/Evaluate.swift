//
// json-functions-swift
//

import Foundation
import JSON

struct Evaluate: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let arrayExpression = expression as? ArrayOfExpressions,
              let expressionExpression = arrayExpression.expressions[safe: 0],
              let parametersExpression = arrayExpression.expressions[safe: 1]
        else {
            throw ParseError.InvalidParameters("Evaluate: Expected two parameters")
        }

        let expressionResult = try expressionExpression.eval(with: &data)
        let expression = try Parser(json: expressionResult).parse()

        let parametersResult = try parametersExpression.eval(with: &data)

        return try expression.eval(with: parametersResult)
    }

}
