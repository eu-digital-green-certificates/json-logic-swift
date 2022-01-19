//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayFind: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case let .Array(dataArray) = try array.expressions[0].eval(with: &data)
            else {
                return .Null
        }

        let findOperation = array.expressions[1]

        if let elementKey = try array.expressions[safe: 2]?.eval(with: &data).string, data.type == .object {
            return try dataArray.first {
                data[elementKey] = $0
                return try findOperation.eval(with: &data).truthy()
            } ?? .Null
        } else {
            return try dataArray.first {
                return try findOperation.eval(with: $0).truthy()
            } ?? .Null
        }
    }

}
