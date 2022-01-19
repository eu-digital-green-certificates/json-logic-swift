//
// json-functions-swift
//

import Foundation
import JSON

struct Comparison: Expression {

    let arg: Expression
    let operation: (JSON, JSON) -> Bool

    func eval(with data: inout JSON) throws -> JSON {
        let result = try arg.eval(with: &data)
        switch result {
        case let .Array(array) where array.count == 2:
            if case .String(_) = array[0],
                case .String(_) = array[1] {
                return JSON(booleanLiteral: operation(array[0], array[1]))
            }

            return .Bool(operation(array[0], array[1]))
        case let .Array(array) where array.count == 3:
            return .Bool(operation(array[0], array[1])
                                     && operation(array[1], array[2]))
        default:
            return JSON(false)
        }
    }

}
