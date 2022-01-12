//
// json-functions-swift
//

import Foundation
import JSON

struct Evaluate: Expression {

    let expressionExpression: Expression
    let parametersExpression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let expressionResult = try expressionExpression.evalWithData(data)

        let expression = try Parser(json: expressionResult).parse()

        let parametersResult = try parametersExpression.evalWithData(data)

        return try expression.evalWithData(parametersResult)
    }

}
