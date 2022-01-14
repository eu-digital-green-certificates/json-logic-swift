//
// json-functions-swift
//

import Foundation
import JSON

extension Date {

    func timeUntil(_ date: Date, unit: String) -> JSON {
        switch unit {
        case "year":
            guard let result = Calendar.utc.dateComponents([.year], from: self, to: date).year else {
                return JSON.Null
            }
            return JSON(result)
        case "month":
            guard let result = Calendar.utc.dateComponents([.month], from: self, to: date).month else {
                return JSON.Null
            }
            return JSON(result)
        case "day":
            guard let result = Calendar.utc.dateComponents([.day], from: self, to: date).day else {
                return JSON.Null
            }
            return JSON(result)
        case "hour":
            guard let result = Calendar.utc.dateComponents([.hour], from: self, to: date).hour else {
                return JSON.Null
            }
            return JSON(result)
        case "minute":
            guard let result = Calendar.utc.dateComponents([.minute], from: self, to: date).minute else {
                return JSON.Null
            }
            return JSON(result)
        case "second":
            guard let result = Calendar.utc.dateComponents([.second], from: self, to: date).second else {
                return JSON.Null
            }
            return JSON(result)
        default:
            return JSON.Null
        }
    }
    
}
