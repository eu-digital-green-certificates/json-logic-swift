//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayMap: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case let .Array(dataArray) = try array.expressions[0].evalWithData(data)
            else {
                return []
        }

        let mapOperation = array.expressions[1]

        if let elementKey = try array.expressions[safe: 2]?.evalWithData(data).string, var dataDictionary = data?.dictionary {
            let mappedArray: [JSON] = try dataArray.map {
                dataDictionary[elementKey] = $0
                return try mapOperation.evalWithData(JSON(dataDictionary))
            }

            return JSON(mappedArray)
        } else {
            let mappedArray = try dataArray.map {
                return try mapOperation.evalWithData($0)
            }

            return JSON(mappedArray)
        }
    }
    
}
