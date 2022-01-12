//
// json-functions-swift
//

import Foundation
import JSON

struct Script: Expression {

    let expressions: [Expression]

    func evalWithData(_ data: JSON?) throws -> JSON {
        return try evalExpressionsWithData(expressions: expressions, data)
    }

    func evalExpressionsWithData(expressions: [Expression], _ data: JSON?) throws -> JSON {
        var expressions = expressions

        if let expression = expressions.first {
            do {
                let result = try expression.evalWithData(data)

                expressions.remove(at: 0)

                return try evalExpressionsWithData(expressions: expressions, result)
            } catch JsonFunctionsError.returnJSON(let returnData) {
                return returnData
            }
        } else {
            return .Null
        }
    }

}
