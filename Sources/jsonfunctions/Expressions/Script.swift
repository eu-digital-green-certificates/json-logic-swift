//
// json-functions-swift
//

import Foundation
import JSON

struct Script: Expression {

    let expression: Expression

    func eval(with data: inout JSON) throws -> JSON {
        guard let expressions = (expression as? ArrayOfExpressions)?.expressions else {
            throw ParseError.InvalidParameters("Script: Expected array of parameters")
        }

        var scopedData = data
        do {
            try expressions.forEach {
                _ = try $0.eval(with: &scopedData)
            }
        } catch JsonFunctionsError.returnJSON(let returnData) {
            return returnData
        }

        return .Null
    }

}
