//
//  DateHelper.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 8/1/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation

extension Date {
    
    // Convert local time to UTC (or GMT)
    public func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    public func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}

extension String {
    public func fromUTCToLocalTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        var formattedString = self.replacingOccurrences(of: "Z", with: "")
        if let lowerBound = formattedString.range(of: ".")?.lowerBound {
            formattedString = "\(formattedString[..<lowerBound])"
        }
        
        guard let date = dateFormatter.date(from: formattedString) else {
            return self
        }
        
        //dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    public func fromUTCToLocalDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        var formattedString = self.replacingOccurrences(of: "Z", with: "")
        if let lowerBound = formattedString.range(of: ".")?.lowerBound {
            formattedString = "\(formattedString[..<lowerBound])"
        }
        
        guard let date = dateFormatter.date(from: formattedString) else {
            return self
        }
        
        //dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
}

extension Date {
    
    func asString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String{
        let formater = DateFormatter()
        formater.dateStyle = dateStyle
        formater.timeStyle = timeStyle
        formater.timeZone = .current
        formater.locale = .current
        return formater.string(from: self)
    }
    
}
