//
// json-functions-swift
//

import Foundation
import JSON

//swiftlint:disable:next type_name
struct If: Expression {

    let arg: ArrayOfExpressions

    func eval(with data: inout JSON) throws -> JSON {
        return try IfWithExpressions(arg.expressions, and: &data)
    }

    func IfWithExpressions(_ expressions: [Expression], and data: inout JSON) throws -> JSON {
        if expressions.isEmpty {
            return .Null
        } else if expressions.count == 1 {
            return try expressions[0].eval(with: &data)
        } else if try expressions[0].eval(with: &data).truthy() {
            return try expressions[1].eval(with: &data)
        } else if arg.expressions.count == 3 {
            return try expressions[2].eval(with: &data)
        } else {
            return try IfWithExpressions(Array(expressions.dropFirst(2)), and: &data)
        }
    }
    
}
