//
// json-functions-swift
//

import Foundation
import JSON

//swiftlint:disable:next type_name
struct In: Expression {

    let stringExpression: Expression
    let collectionExpression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        if let stringToSearchIn = try collectionExpression.eval(with: &data).string {
            guard let stringToFind = try stringExpression.eval(with: &data).string
                else {
                return false;
            }
            return JSON(stringToSearchIn.contains(stringToFind))
        } else if let arrayToSearchIn = try collectionExpression.eval(with: &data).array {
            let itemToFind = try stringExpression.eval(with: &data)
            return JSON(arrayToSearchIn.contains(itemToFind))
        }
        return false
    }
    
}
