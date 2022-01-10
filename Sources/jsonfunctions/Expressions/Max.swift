//
// json-functions-swift
//

import Foundation
import JSON

struct Max: Expression {

    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard case let .Array(array) = try arg.evalWithData(data) else {
            return .Null
        }

        return array.max() ?? .Null
    }
    
}
