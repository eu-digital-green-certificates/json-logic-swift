//
// json-functions-swift
//

import Foundation
import JSON

struct PlusTime: Expression {

    let expression: Expression
    
    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)
        
        if let arr = result.array,
           let time = arr[0].date,
           let amount = arr[1].int,
           let unit = arr[2].string
           {
            return time.addTime(Int(amount), as: unit)
        }

        return .Null
    }

}
