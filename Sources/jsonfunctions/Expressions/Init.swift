//
// json-functions-swift
//

import Foundation
import JSON

struct Init: Expression {

    let expressions: [Expression]

    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let result = try expressions.first?.evalWithData(data) else {
            throw ParseError.InvalidParameters("Init: Expected at least two parameters, got none")
        }

        switch result.string {
        case "literal":
            return try evalLiteralWithData(data)
        case "object":
            return try evalDictionaryWithData(data)
        case "array":
            return try evalArrayWithData(data)
        default:
            throw ParseError.InvalidParameters("Init: Unsupported type")
        }
    }

    func evalLiteralWithData(_ data: JSON?) throws -> JSON {
        guard let result = try expressions[safe: 1]?.evalWithData(data) else {
            throw ParseError.InvalidParameters("Init: Expected at least two parameters, got only one")
        }

        guard result.array == nil, result.dictionary == nil else {
            throw ParseError.InvalidParameters("Init: Expected literal value")
        }

        return result
    }

    func evalDictionaryWithData(_ data: JSON?) throws -> JSON {
        var targetDictionary = [String: JSON]()
        let expressions = Array(expressions.dropFirst())

        var i = 0
        while i < expressions.count {
            let result = try expressions[i].evalWithData(data)

            if expressions[i] is Spread {
                if let resultDictionary = result.dictionary {
                    resultDictionary.forEach {
                        targetDictionary[$0] = $1
                    }
                } else if let resultArray = result.array {
                    resultArray.enumerated().forEach {
                        targetDictionary[String($0)] = $1
                    }
                } else if result !== .Null {
                    throw ParseError.InvalidParameters("Init: Expected dictionary, array or null")
                }

                i += 1
            } else {
                let key = try result.keyDescription()

                guard let valueResult = try expressions[safe: i + 1]?.evalWithData(data) else {
                    throw ParseError.InvalidParameters("Init: No value for key \"\(key)\"")
                }

                targetDictionary[key] = valueResult

                i += 2
            }
        }

        return JSON(targetDictionary)
    }

    func evalArrayWithData(_ data: JSON?) throws -> JSON {
        var targetArray = [JSON]()
        let expressions = expressions.dropFirst()

        for expression in expressions {
            let result = try expression.evalWithData(data)

            if expression is Spread {
                guard let resultArray = result.array else {
                    throw ParseError.InvalidParameters("Init: Expected array")
                }

                targetArray.append(contentsOf: resultArray)
            } else {
                targetArray.append(result)
            }
        }

        return JSON(targetArray)
    }

}

private extension JSON {

    func keyDescription() throws -> String {
        switch self {
        case .Null:
            throw ParseError.InvalidParameters("Init: Can't use null as key")
        case .Array:
            throw ParseError.InvalidParameters("Init: Can't use array as key")
        case .Dictionary:
            throw ParseError.InvalidParameters("Init: Can't use dictionary as key")
        case .Int(let int64):
            return "\(int64)"
        case .Double(let double):
            return "\(double)"
        case .String(let string):
            return string
        case .Date:
            throw ParseError.InvalidParameters("Init: Can't use date as key")
        case .Bool(let bool):
            return bool ? "true" : "false"
        case .Error(let jSON2Error):
            throw jSON2Error
        }
    }

}
