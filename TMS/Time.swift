//
//  Time.swift
//  TMS
//
//  Created by Y50 on 29/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import Foundation

func timeSince(from: NSDate, numericDates: Bool = false) -> String {
    let calendar = Calendar.current
    let now = NSDate()
    let earliest = now.earlierDate(from as Date)
    let latest = earliest == now as Date ? from : now
    let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
    
    var result = ""
    
    if components.year! >= 2 {
        result = "\(components.year!) years ago"
    } else if components.year! >= 1 {
        if numericDates {
            result = "1 year ago"
        } else {
            result = "Last year"
        }
    } else if components.month! >= 2 {
        result = "\(components.month!) months ago"
    } else if components.month! >= 1 {
        if numericDates {
            result = "1 month ago"
        } else {
            result = "Last month"
        }
    } else if components.weekOfYear! >= 2 {
        result = "\(components.weekOfYear!) weeks ago"
    } else if components.weekOfYear! >= 1 {
        if numericDates {
            result = "1 week ago"
        } else {
            result = "Last week"
        }
    } else if components.day! >= 2 {
        result = "\(components.day!) days ago"
    } else if components.day! >= 1 {
        if numericDates {
            result = "1 day ago"
        } else {
            result = "Yesterday"
        }
    } else if components.hour! >= 2 {
        result = "\(components.hour!) hours ago"
    } else if components.hour! >= 1 {
        if numericDates {
            result = "1 hour ago"
        } else {
            result = "An hour ago"
        }
    } else if components.minute! >= 2 {
        result = "\(components.minute!) minutes ago"
    } else if components.minute! >= 1 {
        if numericDates {
            result = "1 minute ago"
        } else {
            result = "A minute ago"
        }
    } else if components.second! >= 3 {
        result = "\(components.second!) seconds ago"
    } else {
        result = "Just now"
    }
    
    return result
}

func timeAhead(to: NSDate, numericDates: Bool = false) -> String {
    let calendar = Calendar.current
    let now = NSDate()
    let later = now.laterDate(to as Date)
    let latest = later == now as Date ? to : now
    let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: latest as Date, to: later as Date)
    
    var result = ""
    
    if components.year! >= 2 {
        result = "In \(components.year!) years"
    } else if components.year! >= 1 {
        if numericDates {
            result = "In 1 year"
        } else {
            result = "Next year"
        }
    } else if components.month! >= 2 {
        result = "In \(components.month!) months"
    } else if components.month! >= 1 {
        if numericDates {
            result = "In 1 month"
        } else {
            result = "Next month"
        }
    } else if components.weekOfYear! >= 2 {
        result = "In \(components.weekOfYear!) weeks"
    } else if components.weekOfYear! >= 1 {
        if numericDates {
            result = "In 1 week"
        } else {
            result = "Next week"
        }
    } else if components.day! >= 2 {
        result = "In \(components.day!) days"
    } else if components.day! >= 1 {
        if numericDates {
            result = "In 1 day"
        } else {
            result = "Tomorrow"
        }
    } else if components.hour! >= 2 {
        result = "In \(components.hour!) hours"
    } else if components.hour! >= 1 {
        if numericDates {
            result = "In 1 hour"
        } else {
            result = "In An hour"
        }
    } else if components.minute! >= 2 {
        result = "In \(components.minute!) minutes"
    } else if components.minute! >= 1 {
        if numericDates {
            result = "In 1 minute"
        } else {
            result = "In A minute"
        }
    } else if components.second! >= 3 {
        result = "In \(components.second!) seconds"
    } else {
        result = "Just now"
    }
    
    return result
}
