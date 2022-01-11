//
// json-functions-swift
//

import Foundation
import JSON

///  Errors that can be thrown from JsonFunctions methods
public enum JsonFunctionsError: Error, Equatable {

    public static func == (lhs: JsonFunctionsError, rhs: JsonFunctionsError) -> Bool {
        switch (lhs, rhs) {
        case let (canNotParseJSONData(ltype), canNotParseJSONData(rtype)):
                return ltype == rtype
        case let (canNotConvertResultToType(ltype), canNotConvertResultToType(rtype)):
                return ltype == rtype
        case let (canNotParseJSONRule(ltype), canNotParseJSONRule(rtype)):
                return ltype == rtype
        case (.noSuchFunction, .noSuchFunction):
            return true
        default:
            return false
        }
    }

    /// Invalid json data was passed
    case canNotParseJSONData(String)

    /// Invalid json rule was passed
    case canNotParseJSONRule(String)

    /// Could not convert the result from applying the rule to the expected type
    case canNotConvertResultToType(Any.Type)

    case noSuchFunction

}
