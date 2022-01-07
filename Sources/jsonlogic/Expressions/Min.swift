//
//  Min.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct Min: Expression {

    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard case let .Array(array) = try arg.evalWithData(data) else {
            return .Null
        }

        return array.min() ?? .Null
    }

}
