//
//  ArrayOfExpressions.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct ArrayOfExpressions: Expression {

    let expressions: [Expression]

    func evalWithData(_ data: JSON?) throws -> JSON {
        return .Array(try expressions.map({ try $0.evalWithData(data) }))
    }
    
}
