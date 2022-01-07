//
//  Trim.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation

extension Array {

    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }

}
