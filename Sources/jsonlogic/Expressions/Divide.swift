//
// json-functions-swift
//

import Foundation
import JSON

struct Divide: Expression {

    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            return array[0].toNumber() / array[1].toNumber()
        default:
            return .Null
        }
    }
    
}
