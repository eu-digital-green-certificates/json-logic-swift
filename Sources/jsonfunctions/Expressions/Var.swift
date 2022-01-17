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
        let variablePathAsJSON = try self.expression.eval(with: &data)

        switch variablePathAsJSON {
        case let .String(string):
            variablePath = string
            defaultValue = .Null
        case let .Array(array):
            variablePath = array.first?.string
            defaultValue = array[safe: 1] ?? .Null
        default:
            variablePath = nil
            defaultValue = .Null
        }

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
