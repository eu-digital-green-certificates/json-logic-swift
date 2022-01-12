//
// json-functions-swift
//

import Foundation
import JSON

struct Trim: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)

        guard let value = result.array?.first else {
            throw ParseError.InvalidParameters("Trim: Expected one parameter")
        }

        let trimmedDescription = try value.innerDescription().trimmingCharacters(in: .whitespacesAndNewlines)

        return JSON(trimmedDescription)
    }

}
