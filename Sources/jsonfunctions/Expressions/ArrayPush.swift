//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayPush: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              case var .Array(targetArray) = try array.expressions[0].eval(with: &data)
            else {
                throw ParseError.InvalidParameters("ArrayPush: Expected array as first parameter")
        }

        for expression in array.expressions.dropFirst() {
            let result = try expression.eval(with: &data)
            targetArray.append(result)
        }

        return JSON(targetArray)
    }
    
}
