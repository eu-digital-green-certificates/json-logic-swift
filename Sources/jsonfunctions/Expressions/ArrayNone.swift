//
// json-functions-swift
//

import Foundation
import JSON

struct ArrayNone: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let array = self.expression as? ArrayOfExpressions,
            array.expressions.count >= 2,
            case let .Array(dataArray) = try array.expressions[0].eval(with: &data)
            else {
                return true
        }
        let operation = array.expressions[1]

        return .Bool(try dataArray.reduce(into: true) {
            $0 = try $0 && !operation.eval(with: $1).truthy()
        })
    }
    
}
