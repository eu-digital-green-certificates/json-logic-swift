//
//  MissingSome.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct MissingSome: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let arg = try expression.evalWithData(data)

        guard case let JSON.Array(array) = arg,
              array.count >= 2,
              case let .Int(minRequired) = array[0],
              case let .Array(keys) = array[1] else {
            return .Null
        }

        let foundKeys = keys.filter({ valueForKey($0.string, in: data) != .Null })
        let missingkeys = { keys.filter({ !foundKeys.contains($0) }) }

        return .Array(foundKeys.count < minRequired ? missingkeys() : [])
    }

    func valueForKey(_ key: String?, in data: JSON?) -> JSON? {
        guard let key = key else { return .Null }
        let variablePathParts = key.split(separator: ".").map({ String($0) })
        var partialResult: JSON? = data
        for key in variablePathParts {
            partialResult = partialResult?[key]
        }

        guard let result = partialResult else {
            return .Null
        }

        if case JSON.Error(_) = result {
            return .Null
        }

        return result
    }

}
