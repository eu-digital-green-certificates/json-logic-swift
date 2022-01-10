//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayReduce: Expression {
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {

        guard let array = self.expression as? ArrayOfExpressions,
              array.expressions.count >= 3,
              let intoValue: JSON = try? array.expressions[2].evalWithData(data)
                else {
            return .Null
        }
        guard case let .Array(dataArray) = try array.expressions[0].evalWithData(data) else {
            return intoValue
        }

        let reduceOperation = array.expressions[1]

        return try dataArray.reduce(into: intoValue) { (result: inout JSON, value: JSON) in
            let reduceContext = JSON(["accumulator": result, "current": value])
            result = try reduceOperation.evalWithData(reduceContext)
        }

    }
}
