//
// json-functions-swift
//

import Foundation
import JSON

struct ReplaceAll: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)

        guard let parameters = result.array,
              let value = parameters[safe: 0],
              let searchValue = parameters[safe: 1],
              let newValue = parameters[safe: 2] else
        {
            throw ParseError.InvalidParameters("ReplaceAll: Expected 3 parameters")
        }

        let innerValueDescription = try value.innerDescription()
        let innerSearchValueDescription = try searchValue.innerDescription()
        let innerNewValueDescription = try newValue.innerDescription()

        if case .Array = value {
            return ""
        } else if case .Dictionary = value {
            return ""
        } else if case .Array = searchValue {
            return value
        } else if case .Dictionary = searchValue {
            return value
        } else if case .Null = searchValue {
            return value
        } else if case .Array = newValue {
            return value
        } else if case .Dictionary = newValue {
            return value
        } else if case .Null = newValue {
            return value
        }

        let replacedAllDescription = innerValueDescription.replacingOccurrences(
            of: innerSearchValueDescription,
            with: innerNewValueDescription
        )

        return JSON(replacedAllDescription)
    }

}
