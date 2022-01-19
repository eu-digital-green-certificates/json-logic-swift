//
// json-functions-swift
//

import Foundation
import JSON

struct ArraySort: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case var .Array(dataArray) = try array.expressions[0].eval(with: &data)
            else {
                return []
        }

        let sortOperation = array.expressions[1]

        try dataArray.sort {
            var dataDictionary = data.dictionary ?? [:]
            dataDictionary["a"] = $1
            dataDictionary["b"] = $0
            return try sortOperation.eval(with: JSON(dataDictionary)).bool ?? false
        }

        return JSON(dataArray)
    }

}
