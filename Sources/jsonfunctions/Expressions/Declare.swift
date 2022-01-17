//
// json-functions-swift
//

import Foundation
import JSON

struct Declare: Expression {

    let identifierExpression: Expression
    let valueExpression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        let identifierResult = try identifierExpression.eval(with: &data)

        guard let identifier = identifierResult.string else {
            throw ParseError.InvalidParameters("Declare: Expected string identifier")
        }

        let valueResult = try valueExpression.eval(with: &data)

        data[identifier] = valueResult

        return .Null
    }

}
