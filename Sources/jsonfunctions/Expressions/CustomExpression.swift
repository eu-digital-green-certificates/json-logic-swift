//
// json-functions-swift
//

import Foundation
import JSON

struct CustomExpression: Expression {

    let expression: Expression
    let customOperator: (JSON?) -> JSON

    func eval(with data: inout JSON) throws -> JSON {
        let result = try expression.eval(with: &data)
        
        return customOperator(result)
    }
    
}
