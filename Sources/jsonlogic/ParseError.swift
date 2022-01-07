//
//  ParseError.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation

public enum ParseError: Error, Equatable {

    case UnimplementedExpressionFor(_ operator: String)
    case GenericError(String)
    case InvalidParameters

}
