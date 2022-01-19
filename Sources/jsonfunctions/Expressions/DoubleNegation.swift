//
// json-functions-swift
//

import Foundation
import JSON

struct DoubleNegation: Expression {

    let arg: Expression

    func eval(with data: inout JSON) throws -> JSON {
        let data = try arg.eval(with: data)
        guard case let JSON.Array(array) = data else {
            return JSON.Bool(data.truthy())
        }
        if let firstItem = array.first {
            return JSON.Bool(firstItem.truthy())
        }
        return JSON.Bool(false)
    }
    
}
