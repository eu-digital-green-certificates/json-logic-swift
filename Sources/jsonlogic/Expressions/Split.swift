//
//  Trim.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct Split: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)

        guard let parameters = result.array,
              let value = parameters[safe: 0],
              let separator = parameters[safe: 1] else
        {
            throw ParseError.InvalidParameters
        }

        let innerValueDescription = try value.innerDescription()
        let innerSeparatorDescription = try separator.innerDescription()

        if case .Array = value {
            return []
        } else if case .Dictionary = value {
            return []
        } else if case .Array = separator {
            return JSON([innerValueDescription])
        } else if case .Dictionary = separator {
            return JSON([innerValueDescription])
        } else if case .Null = separator {
            return JSON([innerValueDescription])
        } else if innerSeparatorDescription.isEmpty {
            return JSON(Array(innerValueDescription).map { String($0) })
        }

        let splitDescription = innerValueDescription.components(separatedBy: innerSeparatorDescription)

        return JSON(splitDescription)
    }

}
