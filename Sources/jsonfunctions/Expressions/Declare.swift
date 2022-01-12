//
// json-functions-swift
//

import Foundation
import JSON

struct Declare: Expression {

    let identifierExpression: Expression
    let valueExpression: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        let identifierResult = try identifierExpression.evalWithData(data)

        guard let identifier = identifierResult.string else {
            throw ParseError.InvalidParameters("Declare: Expected string identifier")
        }

        let valueResult = try valueExpression.evalWithData(data)

        let newData = data ?? JSON([String: JSON]())
        guard var newDataDictionary = newData.dictionary else {
            throw ParseError.InvalidParameters("Declare: Expected dictionary value")
        }

        newDataDictionary[identifier] = valueResult

        return JSON(newDataDictionary)
    }

}
