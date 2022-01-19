//
// json-functions-swift
//

import Foundation
import JSON

struct ToUpperCase: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        let result = try expression.eval(with: &data)

        guard let value = result.array?.first else {
            throw ParseError.InvalidParameters("ToUpperCase: Expected one parameter")
        }

        let uppercasedDescription = try value.innerDescription().uppercased()

        return JSON(uppercasedDescription)
    }

}
