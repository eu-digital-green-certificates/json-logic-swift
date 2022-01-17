//
// json-functions-swift
//

import Foundation
import JSON

struct LogicalAndOr: Expression {

    let isAnd: Bool
    let arg: ArrayOfExpressions

    func eval(with data: inout JSON) throws -> JSON {
        for expression in arg.expressions {
            let data = try expression.eval(with: &data)
            if data.truthy() == !isAnd {
                return data
            }
        }

        return try arg.expressions.last?.eval(with: &data) ?? .Null
    }
    
}
