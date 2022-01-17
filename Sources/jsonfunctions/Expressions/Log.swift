//
// json-functions-swift
//

import Foundation
import JSON

struct Log: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        let result = try expression.eval(with: &data)
        print("\(String(describing: try result.convertToSwiftTypes()))")
        return result
    }
    
}
