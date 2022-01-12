//
// json-functions-swift
//

import Foundation
import JSON

struct ToUpperCase: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)

        guard let value = result.array?.first else {
            throw ParseError.InvalidParameters("ToUpperCase: Expected one parameter")
        }

        let uppercasedDescription = try value.innerDescription().uppercased()

        return JSON(uppercasedDescription)
    }

}
