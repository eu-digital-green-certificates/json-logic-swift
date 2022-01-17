//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayReduce: Expression {
    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              array.expressions.count >= 3,
              let intoValue: JSON = try? array.expressions[2].eval(with: &data)
                else {
            return .Null
        }

        guard case let .Array(dataArray) = try array.expressions[0].eval(with: &data) else {
            return intoValue
        }

        let reduceOperation = array.expressions[1]

        return try dataArray.reduce(into: intoValue) { (result: inout JSON, value: JSON) in
            var reduceContext = JSON(["accumulator": result, "current": value])
            result = try reduceOperation.eval(with: &reduceContext)
        }

    }
}
