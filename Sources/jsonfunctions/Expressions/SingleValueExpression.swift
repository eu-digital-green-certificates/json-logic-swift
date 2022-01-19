//
// json-functions-swift
//

import Foundation
import JSON

struct SingleValueExpression: Expression {
    
    let json: JSON

    func eval(with data: inout JSON) throws -> JSON {
        return json
    }

}
