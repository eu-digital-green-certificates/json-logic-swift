//
//  JSON+InnerDescription.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

extension JSON {

    func innerDescription() throws -> String {
        switch self {
        case .Null:
            return ""
        case .Array:
            return ""
        case .Dictionary:
            return ""
        case .Int(let int64):
            return "\(int64)"
        case .Double(let double):
            return "\(double)"
        case .String(let string):
            return string
        case .Date:
            return ""
        case .Bool(let bool):
            return bool ? "true" : "false"
        case .Error(let jSON2Error):
            throw jSON2Error
        }
    }

}
