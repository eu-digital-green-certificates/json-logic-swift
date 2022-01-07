//
//  _Expression.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

protocol Expression {

    func evalWithData(_ data: JSON?) throws -> JSON

}
