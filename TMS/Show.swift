//
//  Show.swift
//  TMS
//
//  Created by Y50 on 28/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import RealmSwift

class Genres: Object {
    dynamic var genre: String?
}

class Show: Object {
    
    dynamic var title: String? = "Not Available"
    dynamic var year: Int = -1
    dynamic var id: Int = -1
    dynamic var overview: String? = "Not Available"
    dynamic var firstAired: NSDate?
    dynamic var airDay: String? = "Not Available"
    dynamic var airTime: String? = "Not Available"
    dynamic var timezone: String? = "America/New_York"
    dynamic var runtime: Int = 0
    dynamic var network: String? = "Not Available"
    dynamic var trailer: String?
    dynamic var status: String? = "Not Available"
    dynamic var rating: Int = 0
    var genreList = List<Genres>()
    dynamic var airedEpisodeCount: Int = 0
    dynamic var poster: String? = ""
    dynamic var banner: String? = ""
    dynamic var fanart: String? = ""
    dynamic var thumb: String? = ""
    var seasons = List<Season>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(dictionary: [String:AnyObject]) {
        self.init()
        
        if let title = dictionary[Client.TraktParameters.Title] {
            self.title = title as? String
        }
        
        if let year = dictionary[Client.TraktParameters.Year] {
            self.year = year as! Int
        }
        
        if let id = dictionary[Client.TraktParameters.TraktID] {
            self.id = id as! Int
        }
        
        if let overview = dictionary[Client.TraktParameters.Overview] {
            self.overview = overview as? String
        }
        
        if let firstAired = dictionary[Client.TraktParameters.FirstAired] {
            self.firstAired = firstAired as? NSDate
        }
        
        if let airDay = dictionary[Client.TraktParameters.Day] {
            self.airDay = airDay as? String
        }
        
        if let airTime = dictionary[Client.TraktParameters.Time] {
            self.airTime = airTime as? String
        }
        
        if let timezone = dictionary[Client.TraktParameters.Timezone] {
            self.timezone = timezone as? String
        }
        
        if let runtime = dictionary[Client.TraktParameters.Runtime] {
            self.runtime = runtime as! Int
        }
        
        if let network = dictionary[Client.TraktParameters.Network] {
            self.network = network as? String
        }
        
        if let status = dictionary[Client.TraktParameters.Status] {
            self.status = status as? String
        }
        
        if let rating = dictionary[Client.TraktParameters.Rating] {
            self.rating = rating as! Int
        }
        
        if let genreList = dictionary[Client.TraktParameters.Genre] {
            self.genreList = genreList as! List<Genres>
        }
        
        if let airedEpisodeCount = dictionary[Client.TraktParameters.EpisodeCount] {
            self.airedEpisodeCount = airedEpisodeCount as! Int
        }
        
        if let poster = dictionary[Client.TraktParameters.Poster] {
            self.poster = poster as? String
        }
        
        if let banner = dictionary[Client.TraktParameters.Banner] {
            self.banner = banner as? String
        }
        
        if let fanart = dictionary[Client.TraktParameters.Fanart] {
            self.fanart = fanart as? String
        }
        
        if let thumb = dictionary[Client.TraktParameters.Thumb] {
            self.thumb = thumb as? String
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
