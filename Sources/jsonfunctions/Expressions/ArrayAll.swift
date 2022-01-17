//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayAll: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              array.expressions.count >= 2,
              case let .Array(dataArray) = try array.expressions[0].eval(with: &data),
              !dataArray.isEmpty
                else {
            return false
        }

        let operation = array.expressions[1]

        if let elementKey = try array.expressions[safe: 2]?.eval(with: &data).string, data.type == .object {
            let allSatisfy = try dataArray.allSatisfy {
                data[elementKey] = $0
                return try operation.eval(with: &data).truthy()
            }

            return JSON(allSatisfy)
        } else {
            let allSatisfy = try dataArray.allSatisfy {
                try operation.eval(with: $0).truthy()
            }

            return JSON(allSatisfy)
        }
    }

}
