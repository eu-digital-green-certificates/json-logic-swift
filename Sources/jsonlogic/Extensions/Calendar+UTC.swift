//
//  Calendar+UTC.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation

extension Calendar {

    static var utc: Calendar {
        guard let utc = TimeZone(identifier: "UTC") else {
            return Calendar.current
        }

        var tmpCalendar = Calendar(identifier: .gregorian)
        tmpCalendar.timeZone = utc

        return tmpCalendar
    }
    
}
