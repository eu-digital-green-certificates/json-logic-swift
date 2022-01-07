//
//  Substr.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

struct Substr: Expression {

    let stringExpression: Expression
    let startExpression: Expression
    let lengthExpression: Expression?

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let str = try stringExpression.evalWithData(data).string,
              case let .Int(start) = try startExpression.evalWithData(data)
            else {
                return .Null
        }
        let startIndex = str.index(start >= 0 ? str.startIndex : str.endIndex,
                                    offsetBy: Int(start))

        if lengthExpression != nil {
            if case let .Int(length)? = try lengthExpression?.evalWithData(data) {
                let endIndex = str.index(length >= 0 ? startIndex : str.endIndex,
                                         offsetBy: Int(length))
                return .String(String(str[startIndex..<endIndex]))
            } else {
                return .Null
            }
        } else {
            return .String(String(str[startIndex..<str.endIndex]))
        }
    }

}
