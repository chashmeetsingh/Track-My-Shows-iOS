//
//  Show.swift
//  TMS
//
//  Created by Y50 on 28/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import RealmSwift

class Show: Object {
    
    dynamic var overview: String?
    dynamic var poster: String?
    dynamic var title: String?
    dynamic var status: String?
    dynamic var thumb: String?
    dynamic var traktID: Int = -1
    dynamic var tvdbID: Int = -1
    var watchers: Int? = 0
    var year: Int? = 0
    dynamic var actors: String?
    dynamic var airTime: String?
    dynamic var banner: String?
    dynamic var fanart: String?
    dynamic var firstAired: String?
    dynamic var genre: String?
    dynamic var showID: Int = -1
    dynamic var network: String?
    var rating: Double? = 0.0
    var ratingCount: Int? = 0
    var runtime: Int? = 0
    dynamic var timezone: String?
    var episodes = List<Episode>()
    
    override static func primaryKey() -> String? {
        return "showID"
    }
    
    convenience init(dictionary: [String:AnyObject]) {
        self.init()
        
        if let overview = dictionary[Client.MyAPIResponseKeys.Overview] {
            self.overview = overview as? String
        } else {
            self.overview = "Not Available"
        }
        
        if let poster = dictionary[Client.MyAPIResponseKeys.Poster] {
            self.poster = poster as? String
        } else {
            self.poster = nil
        }
        
        if let title = dictionary[Client.MyAPIResponseKeys.Title] {
            self.title = title as? String
        } else {
            self.title = "Not Available"
        }
        
        if let status = dictionary[Client.MyAPIResponseKeys.Status] {
            self.status = status as? String
        } else {
            self.status = "Not Available"
        }
        
        if let thumb = dictionary[Client.MyAPIResponseKeys.Thumb] {
            self.thumb = thumb as? String
        } else {
            self.thumb = nil
        }
        
        if let traktID = dictionary[Client.MyAPIResponseKeys.TraktID] {
            self.traktID = traktID as! Int
        } else {
            self.traktID = -1
        }
        
        if let tvdbID = dictionary[Client.MyAPIResponseKeys.TvdbID] {
            self.tvdbID = tvdbID as! Int
        } else {
            self.tvdbID = -1
        }
        
        if let watchers = dictionary[Client.MyAPIResponseKeys.watchers] {
            self.watchers = watchers as? Int
        } else {
            self.watchers = nil
        }
        
        if let year = dictionary[Client.MyAPIResponseKeys.Year] {
            self.year = year as? Int
        } else {
            self.year = nil
        }
        
        if let actors = dictionary[Client.MyAPIResponseKeys.Actors] {
            self.actors = actors as? String
        } else {
            self.actors = nil
        }
        
        if let airTime = dictionary[Client.MyAPIResponseKeys.AirTime] {
            self.airTime = airTime as? String
        } else {
            self.airTime = nil
        }
        
        if let banner = dictionary[Client.MyAPIResponseKeys.Banner] {
            self.banner = banner as? String
        } else {
            self.banner = nil
        }
        
        if let fanart = dictionary[Client.MyAPIResponseKeys.Fanart] {
            self.fanart = fanart as? String
        } else {
            self.fanart = nil
        }
        
        if let firstAired = dictionary[Client.MyAPIResponseKeys.FirstAired] {
            self.firstAired = firstAired as? String
        } else {
            self.firstAired = nil
        }
        
        if let genre = dictionary[Client.MyAPIResponseKeys.Genre] {
            self.genre = genre as? String
        } else {
            self.genre = "Not Available"
        }
        
        if let showID = dictionary[Client.MyAPIResponseKeys.showID] {
            self.showID = showID as! Int
        } else {
            self.showID = -1
        }
        
        if let network = dictionary[Client.MyAPIResponseKeys.Network] {
            self.network = network as? String
        } else {
            self.network = "Not Available"
        }
        
        if let rating = dictionary[Client.MyAPIResponseKeys.Rating] {
            self.rating = rating as? Double
        } else {
            self.rating = nil
        }
        
        if let ratingCount = dictionary[Client.MyAPIResponseKeys.RatingCount] {
            self.ratingCount = ratingCount as? Int
        } else {
            self.ratingCount = nil
        }
        
        if let runtime = dictionary[Client.MyAPIResponseKeys.Runtime] {
            self.runtime = runtime as? Int
        } else {
            self.runtime = nil
        }
        
        if let timezone = dictionary[Client.MyAPIResponseKeys.Timezone] {
            self.timezone = timezone as? String
        } else {
            self.timezone = "America/New_York"
        }
        
    }
    
    static func showsFromResults(_ results: [[String:AnyObject]]) -> [Show] {
        
        var shows = [Show]()
        
        for result in results {
            shows.append(Show(dictionary: result))
        }
        
        return shows
        
    }
    
    static func getShowFromResult(_ result: [String:AnyObject]) -> Show {
        
        let show = Show(dictionary: result)
        
        show.episodes = getEpisodesFromResponse(show, seasons: result[Client.MyAPIResponseKeys.Seasons] as! NSArray)

        return show
        
    }
    
    static func getEpisodesFromResponse(_ show: Show, seasons: NSArray) -> List<Episode> {
        
        let episodes = List<Episode>()
        
        for season in seasons {
            let season = season as! [String:AnyObject]
            let result = season[Client.MyAPIResponseKeys.Episodes] as! NSArray
            let seasonNumber = season[Client.MyAPIResponseKeys.SeasonNo] as! Int
            
            for episode in result {
                var data = episode as! [String : AnyObject]
                data[Client.MyAPIResponseKeys.SeasonNo] = seasonNumber as AnyObject?
                data[Client.MyAPIResponseKeys.Timezone] = show.timezone! as AnyObject?
                
                let episode = Episode(dictionary: data)
                episode.show = show
                episodes.append(episode)
            }
        }
        
        return episodes
        
    }
    
}
