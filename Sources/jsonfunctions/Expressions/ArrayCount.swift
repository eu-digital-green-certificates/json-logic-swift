//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayCount: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              case let .Array(dataArray) = try array.expressions[0].eval(with: &data)
                else {
            return 0
        }

        return JSON(dataArray.count)
    }

}
