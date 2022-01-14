//
// json-functions-swift
//

import Foundation
import JSON

struct ArraySome: Expression {
    
    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              array.expressions.count >= 2,
              case let .Array(dataArray) = try array.expressions[0].evalWithData(data)
                else {
            return false
        }

        let operation = array.expressions[1]

        if let elementKey = try array.expressions[safe: 2]?.evalWithData(data).string, var dataDictionary = data?.dictionary {
            let someSatisfy = try dataArray.contains {
                dataDictionary[elementKey] = $0
                return try operation.evalWithData(JSON(dataDictionary)).truthy()
            }

            return JSON(someSatisfy)
        } else {
            let someSatisfy = try dataArray.contains {
                try operation.evalWithData($0).truthy()
            }

            return JSON(someSatisfy)
        }
    }

}
