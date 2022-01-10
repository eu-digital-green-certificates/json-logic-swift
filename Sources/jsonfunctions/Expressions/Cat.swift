//
// json-functions-swift
//

import Foundation
import JSON

struct Cat: Expression {

    let arg: Expression

    func evalWithData(_ data: JSON?) throws -> JSON {
        var result = ""

        let evaluation = try arg.evalWithData(data)
        switch evaluation {
        case let .Array(array):
            result = array.reduce(into: "") { (result, element) in
                result.append(stringFromJSON(element))
            }
        default:
            result = stringFromJSON(evaluation)
        }

        return JSON(result)
    }

    private func stringFromJSON(_ json: JSON) -> String {
        switch json {
        case let .Bool(bool):
            return "\(bool)"
        case let .Double(number):
            return "\(number)"
        case let .Int(number):
            return "\(number)"
        case let .String(string):
            return string
        case let .Array(array):
            return array.map({stringFromJSON($0)}).joined(separator: ",")
        case .Dictionary:
            return ""
        default:
            return ""
        }
    }

}
