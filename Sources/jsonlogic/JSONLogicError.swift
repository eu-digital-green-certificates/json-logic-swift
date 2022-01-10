//
// json-functions-swift
//

import Foundation
import JSON

///  Errors that can be thrown from JsonLogic methods
public enum JSONLogicError: Error, Equatable {
    public static func == (lhs: JSONLogicError, rhs: JSONLogicError) -> Bool {
        switch lhs {
        case let canNotParseJSONData(ltype):
            if case let canNotParseJSONData(rtype) = rhs {
                return ltype == rtype
            }
            return false
        case let canNotConvertResultToType(ltype):
            if case let canNotConvertResultToType(rtype) = rhs {
                return ltype == rtype
            }
            return false
        case let .canNotParseJSONRule(ltype):
            if case let canNotParseJSONRule(rtype) = rhs {
                return ltype == rtype
            }
            return false
        }
    }

    /// Invalid json data was passed
    case canNotParseJSONData(String)

    /// Invalid json rule was passed
    case canNotParseJSONRule(String)

    /// Could not convert the result from applying the rule to the expected type
    case canNotConvertResultToType(Any.Type)
}
