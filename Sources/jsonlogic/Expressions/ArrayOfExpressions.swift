//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayOfExpressions: Expression {

    let expressions: [Expression]

    func evalWithData(_ data: JSON?) throws -> JSON {
        return .Array(try expressions.map({ try $0.evalWithData(data) }))
    }
    
}
