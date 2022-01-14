//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayFilter: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case let .Array(dataArray) = try array.expressions[0].evalWithData(data)
            else {
                return .Array([])
        }

        let filterOperation = array.expressions[1]

        if let elementKeyJSON = try array.expressions[safe: 2]?.evalWithData(data), var dataDictionary = data?.dictionary {
            guard let elementKey = elementKeyJSON.string else {
                throw ParseError.InvalidParameters("ArrayFilter: Expected key to be string")
            }

            let filteredArray = try dataArray.filter {
                dataDictionary[elementKey] = $0
                return try filterOperation.evalWithData(JSON(dataDictionary)).truthy()
            }

            return JSON(filteredArray)
        } else {
            let filteredArray = try dataArray.filter {
                try filterOperation.evalWithData($0).truthy()
            }

            return JSON(filteredArray)
        }
    }
    
}
