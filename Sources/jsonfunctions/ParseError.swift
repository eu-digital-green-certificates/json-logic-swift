//
// json-functions-swift
//

import Foundation

public enum ParseError: Error, Equatable {

    case UnimplementedExpressionFor(_ operator: String)
    case GenericError(String)
    case InvalidParameters(String)

}
