//
// json-functions-swift
//

import Foundation
import JSON

struct Divide: Expression {

    let arg: Expression

    func eval(with data: inout JSON) throws -> JSON {
        let result = try arg.eval(with: &data)
        switch result {
        case let .Array(array) where array.count == 2:
            return array[0].toNumber() / array[1].toNumber()
        default:
            return .Null
        }
    }
    
}
