//
//  Show.swift
//  TMS
//
//  Created by Y50 on 28/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import RealmSwift

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
    dynamic var trailer: String? = ""
    dynamic var status: String? = "Not Available"
    dynamic var rating: Double = 0.0
    dynamic var airedEpisodeCount: Int = 0
    dynamic var poster: String? = ""
    dynamic var banner: String? = ""
    dynamic var fanart: String? = ""
    dynamic var thumb: String? = ""
    dynamic var watchers: Int = 0
    var seasons = List<Season>()

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(dictionary: [String:AnyObject]) {
        self.init()

        if let watchers = dictionary[Client.TraktParameters.Watchers] as? Int {
            self.watchers = watchers
        }

        if let showDictionary = dictionary[Client.TraktParameters.Show] {

            if let title = showDictionary[Client.TraktParameters.Title] as? String {
                self.title = title
            }

            if let year = showDictionary[Client.TraktParameters.Year] as? Int {
                self.year = year
            }

            if let ids = showDictionary[Client.TraktParameters.IDS] as? [String:AnyObject] {
                if let id = ids[Client.TraktParameters.TraktID] as? Int {
                    self.id = id
                }
            }

            if let overview = showDictionary[Client.TraktParameters.Overview] as? String {
                self.overview = overview
            }

            if let firstAired = showDictionary[Client.TraktParameters.FirstAired] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
                self.firstAired = dateFormatter.date(from: firstAired) as NSDate?
            }

            if let airs = showDictionary[Client.TraktParameters.Airs] as? [String:AnyObject] {

                if let airDay = airs[Client.TraktParameters.Day] as? String {
                    self.airDay = airDay
                }

                if let airTime = airs[Client.TraktParameters.Time] as? String {
                    self.airTime = airTime
                }

                if let timezone = airs[Client.TraktParameters.Timezone] as? String {
                    self.timezone = timezone
                }

            }

            if let runtime = showDictionary[Client.TraktParameters.Runtime] as? Int {
                self.runtime = runtime
            }

            if let network = showDictionary[Client.TraktParameters.Network] as? String {
                self.network = network
            }

            if let trailer = showDictionary[Client.TraktParameters.Trailer] as? String {
                self.trailer = trailer
            }

            if let status = showDictionary[Client.TraktParameters.Status] as? String {
                self.status = status
                self.status?.capitalizeFirstLetter()
            }

            if let rating = showDictionary[Client.TraktParameters.Rating] as? Double {
                self.rating = rating
            }

            if let genreList = showDictionary[Client.TraktParameters.Genre] {
                if let genreList = genreList as? NSArray {
                    for _ in genreList {
                        //self.genreList.append(Genres(value: genre))
                    }
                }
            }

            if let airedEpisodeCount = showDictionary[Client.TraktParameters.AiredEpisodes] as? Int {
                self.airedEpisodeCount = airedEpisodeCount
            }

            if let images = showDictionary[Client.TraktParameters.Images] as? [String:AnyObject] {

                if let poster = images[Client.TraktParameters.Poster]?[Client.TraktParameters.Full] as? String {
                    self.poster = poster
                }

                if let banner = images[Client.TraktParameters.Banner]?[Client.TraktParameters.Full] as? String {
                    self.banner = banner
                }

                if let fanart = images[Client.TraktParameters.Fanart]?[Client.TraktParameters.Full] as? String {
                    self.fanart = fanart
                }

                if let thumb = images[Client.TraktParameters.Thumb]?[Client.TraktParameters.Full] as? String {
                    self.thumb = thumb
                }

            }

        }

    }
    
//    override func setValue(_ value: Any?, forKey key: String) {
//        
//    }

    static func showsFromResults(_ results: [[String:AnyObject]]) -> [Show] {

        var shows = [Show]()

        for result in results {
            shows.append(Show(dictionary: result))
        }

        return shows

    }

}
