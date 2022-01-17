//
// json-functions-swift
//

import Foundation
import JSON

struct Substr: Expression {

    let stringExpression: Expression
    let startExpression: Expression
    let lengthExpression: Expression?

    func eval(with data: inout JSON) throws -> JSON {
        guard let str = try stringExpression.eval(with: &data).string,
              case let .Int(start) = try startExpression.eval(with: &data)
            else {
                return .Null
        }
        let startIndex = str.index(start >= 0 ? str.startIndex : str.endIndex,
                                    offsetBy: Int(start))

        if lengthExpression != nil {
            if case let .Int(length)? = try lengthExpression?.eval(with: &data) {
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
