//
//  LogicalAndOr.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct LogicalAndOr: Expression {

    let isAnd: Bool
    let arg: ArrayOfExpressions

    func evalWithData(_ data: JSON?) throws -> JSON {
        for expression in arg.expressions {
            let data = try expression.evalWithData(data)
            if data.truthy() == !isAnd {
                return data
            }
        }

        return try arg.expressions.last?.evalWithData(data) ?? .Null
    }
    
}
