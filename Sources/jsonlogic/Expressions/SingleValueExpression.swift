//
//  SingleValueExpression.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct SingleValueExpression: Expression {
    
    let json: JSON

    func evalWithData(_ data: JSON?) throws -> JSON {
        return json
    }

}
