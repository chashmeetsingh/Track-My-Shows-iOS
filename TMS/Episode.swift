//
//  Episode.swift
//  TMS
//
//  Created by Y50 on 28/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import RealmSwift

class Episode: Object {
    
    dynamic var episodeID: Int = -1
    dynamic var episodeTitle: String?
    dynamic var airDateTime: NSDate?
    dynamic var overview: String?
    dynamic var banner: String?
    var rating: Double?
    var ratingCount: Double?
    dynamic var writer: String?
    dynamic var watched: Bool = false
    dynamic var episodeNumber: Int = -1
    dynamic var seasonNumber: Int = -1
    dynamic var show: Show?
    
    override static func primaryKey() -> String? {
        return "episodeID"
    }
    
    convenience init(dictionary: [String:AnyObject]) {
        self.init()
        
        let timezone: String
        if let timezoneString = dictionary[Client.MyAPIResponseKeys.Timezone] {
            timezone = timezoneString as! String
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
            dateFormatter.timeZone = NSTimeZone(name: timezone)
            
            if let airDateTime = dictionary[Client.MyAPIResponseKeys.AirDateTime] {
                if let dateString = airDateTime as? String {
                    if let airDetails = dateFormatter.dateFromString(dateString){
                        self.airDateTime = airDetails
                    } else {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        if let airDetails = dateFormatter.dateFromString(dateString){
                            self.airDateTime = airDetails
                        } else {
                            dateFormatter.dateFormat = "yyyy-MM-dd ha"
                            if let airDetails = dateFormatter.dateFromString(dateString) {
                                self.airDateTime = airDetails
                            } else {
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                if let airDetails = dateFormatter.dateFromString(dateString) {
                                    self.airDateTime = airDetails
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if let episodeNumber = dictionary[Client.MyAPIResponseKeys.EpisodeNo] as? String {
            self.episodeNumber = (episodeNumber as NSString).integerValue
        } else {
            self.episodeNumber = -1
        }
        
        if let episodeID = dictionary[Client.MyAPIResponseKeys.EpisodeID] {
            self.episodeID = episodeID as! Int
        } else {
            self.episodeID = -1
        }
        
        if let banner = dictionary[Client.MyAPIResponseKeys.Image] {
            self.banner = banner as? String
        } else {
            self.banner = ""
        }
        
        if let overview = dictionary[Client.MyAPIResponseKeys.Overview] {
            self.overview = overview as? String
        } else {
            self.overview = "Not Available"
        }
        
        if let rating = dictionary[Client.MyAPIResponseKeys.Rating] {
            self.rating = rating as? Double
        } else {
            self.rating = 0
        }
        
        if let ratingCount = dictionary[Client.MyAPIResponseKeys.RatingCount] {
            self.ratingCount = ratingCount as? Double
        } else {
            self.ratingCount = 0.0
        }
        
        if let episodeTitle = dictionary[Client.MyAPIResponseKeys.Title] {
            self.episodeTitle = episodeTitle as? String
        } else {
            self.episodeTitle = "Not Available"
        }
        
        if let writer = dictionary[Client.MyAPIResponseKeys.Writer] {
            self.writer = writer as? String
        } else {
            self.writer = "Not Available"
        }
        
        if let watched = dictionary[Client.MyAPIResponseKeys.Watched] {
            self.watched = watched as! Bool
        }
        
        if let seasonNumber = dictionary[Client.MyAPIResponseKeys.SeasonNo] {
            self.seasonNumber = seasonNumber as! Int
        }
        
    }
    
}