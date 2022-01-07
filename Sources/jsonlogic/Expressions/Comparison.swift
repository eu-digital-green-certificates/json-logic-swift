//
//  Comparison.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct Comparison: Expression {

    let arg: Expression
    let operation: (JSON, JSON) -> Bool

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try arg.evalWithData(data)
        switch result {
        case let .Array(array) where array.count == 2:
            if case .String(_) = array[0],
                case .String(_) = array[1] {
                return JSON(booleanLiteral: operation(array[0], array[1]))
            }

            return .Bool(operation(array[0], array[1]))
        case let .Array(array) where array.count == 3:
            return .Bool(operation(array[0], array[1])
                                     && operation(array[1], array[2]))
        default:
            return JSON(false)
        }
    }

}
