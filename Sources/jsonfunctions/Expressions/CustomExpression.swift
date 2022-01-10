//
// json-functions-swift
//

import Foundation
import JSON

struct CustomExpression: Expression {

    let expression: Expression
    let customOperator: (JSON?) -> JSON

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)
        
        return customOperator(result)
    }
    
}
