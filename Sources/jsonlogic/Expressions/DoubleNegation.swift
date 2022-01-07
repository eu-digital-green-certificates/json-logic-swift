//
//  DoubleNegation.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct DoubleNegation: Expression {

    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        return .Bool(try arg.evalWithData(data).truthy())
    }
    
}
