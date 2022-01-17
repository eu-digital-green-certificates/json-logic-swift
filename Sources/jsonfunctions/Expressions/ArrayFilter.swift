//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayFilter: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case let .Array(dataArray) = try array.expressions[0].eval(with: &data)
            else {
                return .Array([])
        }

        let filterOperation = array.expressions[1]

        if let elementKeyJSON = try array.expressions[safe: 2]?.eval(with: &data), data.type == .object {
            guard let elementKey = elementKeyJSON.string else {
                throw ParseError.InvalidParameters("ArrayFilter: Expected key to be string")
            }

            let filteredArray = try dataArray.filter {
                data[elementKey] = $0
                return try filterOperation.eval(with: &data).truthy()
            }

            return JSON(filteredArray)
        } else {
            let filteredArray = try dataArray.filter {
                try filterOperation.eval(with: $0).truthy()
            }

            return JSON(filteredArray)
        }
    }
    
}
