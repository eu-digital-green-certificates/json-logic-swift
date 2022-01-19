//
// json-functions-swift
//

import Foundation
import JSON

struct StrictEquals: Expression {

    let lhs: Expression
    let rhs: Expression

    func eval(with data: inout JSON) throws -> JSON {
        return .Bool((try lhs.eval(with: &data)) === (try rhs.eval(with: &data)))
    }

}
