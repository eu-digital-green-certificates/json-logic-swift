//
// json-functions-swift
//

import Foundation
import JSON

struct Return: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try expression.evalWithData(data)

        guard let value = result.array?.first else {
            throw ParseError.InvalidParameters("Return: Expected array with one element")
        }

        throw JsonFunctionsError.returnJSON(value)
    }

}
