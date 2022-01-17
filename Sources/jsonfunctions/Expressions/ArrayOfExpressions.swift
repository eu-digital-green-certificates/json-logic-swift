//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayOfExpressions: Expression {

    let expressions: [Expression]

    func eval(with data: inout JSON) throws -> JSON {
        return .Array(try expressions.map({ try $0.eval(with: &data) }))
    }
    
}
