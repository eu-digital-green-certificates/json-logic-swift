//
// json-functions-swift
//

import Foundation
import JSON

struct LogicalAndOr: Expression {

    let isAnd: Bool
    let arg: ArrayOfExpressions

    func evalWithData(_ data: JSON?) throws -> JSON {
        for expression in arg.expressions {
            let data = try expression.evalWithData(data)
            if data.truthy() == !isAnd {
                return data
            }
        }

        return try arg.expressions.last?.evalWithData(data) ?? .Null
    }
    
}
