//
//  Modulo.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct Modulo: Expression {

    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let result = try arg.evalWithData(data)
        
        switch result {
        case let .Array(array) where array.count == 2:
            return array[0] % array[1]
        default:
            return .Null
        }
    }

}
