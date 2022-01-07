//
//  StrictEquals.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct StrictEquals: Expression {

    let lhs: Expression
    let rhs: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        return .Bool((try lhs.evalWithData(data)) === (try rhs.evalWithData(data)))
    }

}
