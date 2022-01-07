//
//  CustomExpression.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
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
