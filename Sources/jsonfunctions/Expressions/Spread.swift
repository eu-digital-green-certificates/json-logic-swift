//
// json-functions-swift
//

import Foundation
import JSON

struct Spread: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        let result = try expression.eval(with: &data)

        return result
    }

}
