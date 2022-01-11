//
// json-functions-swift
//

import Foundation
import JSON

struct Var: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let data = data else {
            return JSON.Null
        }

        let variablePath = try evaluateVarPathFromData(data)
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
            return partialResult ?? JSON.Null
        }

        return .Null
    }

    func evaluateVarPathFromData(_ data: JSON) throws -> String? {
        let variablePathAsJSON = try self.expression.evalWithData(data)

        switch variablePathAsJSON {
        case let .String(string):
            return string
        case let .Array(array):
            return array.first?.string
        default:
            return nil
        }
    }
    
}
