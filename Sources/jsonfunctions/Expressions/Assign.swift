//
// json-functions-swift
//

import Foundation
import JSON

struct Assign: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let data = data else {
            return .Null
        }

        guard let arrayExpression = expression as? ArrayOfExpressions,
              let identifierExpression = arrayExpression.expressions[safe: 0],
              let valueExpression = arrayExpression.expressions[safe: 1]
        else {
            throw ParseError.InvalidParameters("Assign: Expected two parameters")
        }

        guard let identifier = try identifierExpression.evalWithData(data).string else {
            throw ParseError.InvalidParameters("Assign: Expected string for first parameter")
        }

        let value = try valueExpression.evalWithData(data)

        let variablePathParts = Array(
            identifier.split(separator: ".").map({ String($0) }).reversed()
        )

        return set(value: value, at: variablePathParts, in: data)
    }

    private func set(value: JSON, at variablePathParts: [String], in data: JSON) -> JSON {
        var partialData = data
        var partialVariablePathParts = variablePathParts

        guard let key = partialVariablePathParts.popLast() else {
            return data
        }

        var returnedData: JSON?
        if variablePathParts.count > 1 {
            if partialData.type == .array, let index = Int(key), let maxElement = partialData.array?.count, index < maxElement, index >= 0 {
                returnedData = set(value: value, at: partialVariablePathParts, in: partialData[index])
            } else {
                returnedData = set(value: value, at: partialVariablePathParts, in: partialData[key])
            }
        }

        let newData = returnedData ?? value

        if partialData.type == .array, let index = Int(key), let maxElement = partialData.array?.count, index < maxElement, index >= 0 {
            partialData[index] = newData
        } else if let array = partialData.array, let index = Int(key), let maxElement = partialData.array?.count, index == maxElement {
            partialData = JSON(array + [newData])
        } else {
            partialData[key] = newData
        }

        return partialData
    }
    
}
