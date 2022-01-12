//
// json-functions-swift
//

import Foundation
import JSON

struct Spread: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)

        return result
    }

}
