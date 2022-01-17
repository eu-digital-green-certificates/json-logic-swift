//
// json-functions-swift
//

import Foundation
import JSON

struct Evaluate: Expression {

    let expressionExpression: Expression
    let parametersExpression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        let expressionResult = try expressionExpression.eval(with: &data)
        let expression = try Parser(json: expressionResult).parse()

        let parametersResult = try parametersExpression.eval(with: &data)

        return try expression.eval(with: parametersResult)
    }

}
