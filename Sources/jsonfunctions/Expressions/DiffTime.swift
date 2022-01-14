//
// json-functions-swift
//

import Foundation
import JSON

struct DiffTime: Expression {

    let expression: Expression
    
    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)
        
        if let arr = result.array,
           let lhs = arr[0].date,
           let rhs = arr[1].date,
           let unit = arr[2].string
           {
            return rhs.timeUntil(lhs, unit: unit)
        }

        return .Null
    }

}
