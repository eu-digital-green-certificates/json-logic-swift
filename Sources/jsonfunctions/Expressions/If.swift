//
// json-functions-swift
//

import Foundation
import JSON

//swiftlint:disable:next type_name
struct If: Expression {

    let arg: ArrayOfExpressions

    func evalWithData(_ data: JSON?) throws -> JSON {
        return try IfWithExpressions(arg.expressions, andData: data)
    }

    func IfWithExpressions(_ expressions: [Expression], andData data: JSON?) throws -> JSON {
        if expressions.isEmpty {
            return .Null
        } else if expressions.count == 1 {
            return try expressions[0].evalWithData(data)
        } else if try expressions[0].evalWithData(data).truthy() {
            return try expressions[1].evalWithData(data)
        } else if arg.expressions.count == 3 {
            return try expressions[2].evalWithData(data)
        } else {
            return try IfWithExpressions(Array(expressions.dropFirst(2)), andData: data)
        }
    }
    
}
