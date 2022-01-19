//
// json-functions-swift
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
