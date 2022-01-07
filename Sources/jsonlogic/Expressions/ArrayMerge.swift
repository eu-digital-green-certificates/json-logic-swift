//
//  ArrayMerge.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct ArrayMerge: Expression {

    let expression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let dataArray = try expression.evalWithData(data)

        return .Array(recursiveFlattenArray(dataArray))
    }

    func recursiveFlattenArray(_ json: JSON) -> [JSON] {
        switch json {
        case let .Array(array):
            return array.flatMap({ recursiveFlattenArray($0) })
        default:
            return [json]
        }
    }
    
}
