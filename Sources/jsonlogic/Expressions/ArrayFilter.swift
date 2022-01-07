//
//  ArrayFilter.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
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

        return .Array(try dataArray.filter({ try filterOperation.evalWithData($0).truthy() }))
    }
    
}
