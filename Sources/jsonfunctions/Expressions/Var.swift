//
// json-functions-swift
//

import Foundation
import JSON

struct Var: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        let variablePath: String?
        let defaultValue: JSON
        var parameters = try self.expression.eval(with: &data)

        if parameters.type != .array {
            parameters = JSON([parameters])
        }

        switch parameters.array?[safe: 0] {
        case let .String(string) where string.isEmpty:
            return data
        case let .Array(array) where array.isEmpty:
            return data
        case let .String(string):
            variablePath = string
        case let .Int(int):
            variablePath = String(int)
        case .Null,  nil:
            return data
        default:
            variablePath = nil
        }

        defaultValue = parameters.array?[safe: 1] ?? .Null

        guard data !== .Null else {
            return defaultValue
        }

        if let variablePathParts = variablePath?.split(separator: ".").map({String($0)}) {
            var partialResult: JSON? = data
            for key in variablePathParts {
                if partialResult?.type == .array {
                    if let index = Int(key), let maxElement = partialResult?.array?.count, index < maxElement, index >= 0  {
                        partialResult = partialResult?[index]
                    } else {
                        partialResult = partialResult?[key]
                    }
                } else {
                    partialResult = partialResult?[key]
                }
            }

            if let partialResult = partialResult, partialResult !== .Null {
                return partialResult
            } else {
                return defaultValue
            }
        }

        return defaultValue
    }
    
}
