//
// json-functions-swift
//

import Foundation
import JSON

struct SingleValueExpression: Expression {
    
    let json: JSON

    func evalWithData(_ data: JSON?) throws -> JSON {
        return json
    }

}
