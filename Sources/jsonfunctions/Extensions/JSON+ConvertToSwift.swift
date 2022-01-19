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
        case let .Array(array):
            return try array.map { try $0.convertToSwiftTypes() }
        case let .Dictionary(dict):
            return try dict.mapValues {
                try $0.convertToSwiftTypes()
            }
        }
    }

    func decoded<T: Decodable>(to: T.Type) throws -> T {
        let convertedToSwiftStandardType = try convertToSwiftTypes()

        let jsonData = try JSONSerialization.data(withJSONObject: convertedToSwiftStandardType as Any, options: [.fragmentsAllowed])
        return try JSONDecoder().decode(T.self, from: jsonData)
    }

}
