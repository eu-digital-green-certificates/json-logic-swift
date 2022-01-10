//
// json-functions-swift
//

import Foundation
import JSON

struct Multiply: Expression {

    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let total = JSON(1)
        let result = try arg.evalWithData(data)

        switch result {
        case let .Array(array):
            return array.reduce(total) { $0 * ($1.toNumber()) }
        default:
            return result.toNumber()
        }
    }
    
}
