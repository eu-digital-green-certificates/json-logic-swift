//
//  Date+AddTime.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

extension Date {

    func addTime(_ amount: Int, as unit: String) -> JSON {
        switch unit {
        case "year":
            guard let date = Calendar.utc.date(byAdding: .year, value: Int(amount), to: self) else {
                return JSON.Null
            }
            return JSON(date)
        case "month":
            guard let date = Calendar.utc.date(byAdding: .month, value: Int(amount), to: self) else {
                return JSON.Null
            }
            return JSON(date)
        case "day":
            guard let date = Calendar.utc.date(byAdding: .day, value: Int(amount), to: self) else {
                return JSON.Null
            }
            return JSON(date)
        case "hour":
            guard let date = Calendar.utc.date(byAdding: .hour, value: Int(amount), to: self) else {
                return JSON.Null
            }
            return JSON(date)
        case "minute":
            guard let date = Calendar.utc.date(byAdding: .minute, value: Int(amount), to: self) else {
                return JSON.Null
            }
            return JSON(date)
        case "second":
            guard let date = Calendar.utc.date(byAdding: .second, value: Int(amount), to: self) else {
                return JSON.Null
            }
            return JSON(date)
        default:
            return JSON.Null
        }
    }
    
}
