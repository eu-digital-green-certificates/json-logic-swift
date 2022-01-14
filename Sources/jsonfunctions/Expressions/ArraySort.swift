//
// json-functions-swift
//

import Foundation
import JSON

struct ArraySort: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case var .Array(dataArray) = try array.expressions[0].evalWithData(data)
            else {
                return []
        }

        let sortOperation = array.expressions[1]

        try dataArray.sort {
            var dataDictionary = data?.dictionary ?? [:]
            dataDictionary["a"] = $1
            dataDictionary["b"] = $0
            return try sortOperation.evalWithData(JSON(dataDictionary)).bool ?? false
        }

        return JSON(dataArray)
    }

}
