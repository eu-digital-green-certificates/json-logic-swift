//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayPush: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              case var .Array(targetArray) = try array.expressions[0].evalWithData(data)
            else {
                throw ParseError.InvalidParameters("ArrayPush: Expected array as first parameter")
        }

        for expression in array.expressions.dropFirst() {
            let result = try expression.evalWithData(data)
            targetArray.append(result)
        }

        return JSON(targetArray)
    }
    
}
