//
// json-functions-swift
//

import Foundation
import JSON

struct Script: Expression {

    let expressions: [Expression]

    func eval(with data: inout JSON) throws -> JSON {
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
