//
// json-functions-swift
//

import Foundation
import JSON

struct DoubleNegation: Expression {

    let arg: Expression

    func eval(with data: inout JSON) throws -> JSON {
        return .Bool(try arg.eval(with: &data).truthy())
    }
    
}
