//
// json-functions-swift
//

import Foundation
import JSON

struct Spread: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let arrayExpression = expression as? ArrayOfExpressions,
              let firstExpression = arrayExpression.expressions[safe: 0]
        else {
            throw ParseError.InvalidParameters("Spread: Expected one parameter")
        }

        let result = try firstExpression.eval(with: &data)

        return result
    }

}
