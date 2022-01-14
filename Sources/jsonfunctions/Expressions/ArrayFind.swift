//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayFind: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case let .Array(dataArray) = try array.expressions[0].evalWithData(data)
            else {
                return .Null
        }

        let findOperation = array.expressions[1]

        if let elementKey = try array.expressions[safe: 2]?.evalWithData(data).string, var dataDictionary = data?.dictionary {
            return try dataArray.first {
                dataDictionary[elementKey] = $0
                return try findOperation.evalWithData(JSON(dataDictionary)).truthy()
            } ?? .Null
        } else {
            return try dataArray.first {
                return try findOperation.evalWithData($0).truthy()
            } ?? .Null
        }
    }

}
