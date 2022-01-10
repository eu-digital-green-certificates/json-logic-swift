//
// json-functions-swift
//

import Foundation
import JSON

extension JSON {
    func convertToSwiftTypes() throws -> Any? {
        switch self {
        case .Error:
            throw JsonFunctionsError.canNotParseJSONData("\(self)")
        case .Null:
            return Optional<Any>.none
        case .Bool:
            return self.bool
        case .Int:
            return Swift.Int(self.int!)
        case .Double:
            return self.double
        case .String:
            return self.string
        case .Date:
            return self.date
        case let JSON.Array(array):
            return try array.map { try $0.convertToSwiftTypes() }
        case .Dictionary:
            let o = self.dictionary!
            return try o.mapValues {
                try $0.convertToSwiftTypes()
            }
        }
    }
}
