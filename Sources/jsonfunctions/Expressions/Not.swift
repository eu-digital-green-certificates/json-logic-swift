//
// json-functions-swift
//

import Foundation
import JSON

struct Not: Expression {

    let lhs: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let lhsBool = try lhs.evalWithData(data)
        if let array = lhsBool.array
        {
            if(array.count == 0)
            {
                return .Bool(!lhsBool.truthy())
            }
            else
            {
               return .Bool(!array[0].truthy())
            }
        }

        return .Bool(!lhsBool.truthy())
    }
    
}
