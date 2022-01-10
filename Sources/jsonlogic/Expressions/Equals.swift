//
// json-functions-swift
//

import Foundation
import JSON

struct Equals: Expression {

    let lhs: Expression
    let rhs: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        return .Bool((try lhs.evalWithData(data)) == (try rhs.evalWithData(data)))
    }
    
}
