//
//  In.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

//swiftlint:disable:next type_name
struct In: Expression {

    let stringExpression: Expression
    let collectionExpression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        if let stringToSearchIn = try collectionExpression.evalWithData(data).string {
            guard let stringToFind = try stringExpression.evalWithData(data).string
                else {
                return false;
            }
            return JSON(stringToSearchIn.contains(stringToFind))
        } else if let arrayToSearchIn = try collectionExpression.evalWithData(data).array {
            let itemToFind = try stringExpression.evalWithData(data)
            return JSON(arrayToSearchIn.contains(itemToFind))
        }
        return false
    }
    
}
