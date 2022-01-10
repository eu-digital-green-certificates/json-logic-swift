//
// json-functions-swift
//

import Foundation
import JSON

struct DoubleNegation: Expression {

    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        return .Bool(try arg.evalWithData(data).truthy())
    }
    
}
