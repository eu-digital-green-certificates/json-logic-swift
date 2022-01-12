//
// json-functions-swift
//

import Foundation
import JSON

struct ToLowerCase: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)

        guard let value = result.array?.first else {
            throw ParseError.InvalidParameters("ToLowerCase: Expected one parameter")
        }

        let lowercasedDescription = try value.innerDescription().lowercased()

        return JSON(lowercasedDescription)
    }

}
