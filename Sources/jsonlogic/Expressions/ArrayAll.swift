//
//  ArrayAll.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct ArrayAll: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
              array.expressions.count >= 2,
              case let .Array(dataArray) = try array.expressions[0].evalWithData(data)
                else {
            return .Null
        }

        let operation = array.expressions[1]

        return .Bool(try dataArray.reduce(into: !dataArray.isEmpty) {
            $0 = try $0 && operation.evalWithData($1).truthy()
        })
    }

}
