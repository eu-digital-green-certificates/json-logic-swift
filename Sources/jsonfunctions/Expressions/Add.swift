//
// json-functions-swift
//

import Foundation
import JSON

struct Add: Expression {
    
    let arg: Expression
    
    func eval(with data: inout JSON) throws -> JSON {
        let sum = JSON(0)
        let result = try arg.eval(with: &data)
        switch result {
        case let .Array(array):
            return array.reduce(sum) { $0 + ($1.toNumber()) }
        default:
            return result.toNumber()
        }
    }
    
}
