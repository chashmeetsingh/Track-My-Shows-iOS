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
    dynamic var watchers: Int = 0
    var seasons = List<Season>()

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(dictionary: [String:AnyObject]) {
        self.init()

        if let watchers = dictionary[Client.TraktParameters.Watchers] {
            self.watchers = watchers as! Int
        }

        if let showDictionary = dictionary[Client.TraktParameters.Show] {

            if let title = showDictionary[Client.TraktParameters.Title] {
                self.title = title as? String
            }

            if let year = showDictionary[Client.TraktParameters.Year] {
                self.year = year as! Int
            }

            if let ids = showDictionary[Client.TraktParameters.IDS] as? [String:AnyObject] {
                if let id = ids[Client.TraktParameters.TraktID] {
                    self.id = id as! Int
                }
            }

            if let overview = showDictionary[Client.TraktParameters.Overview] {
                self.overview = overview as? String
            }

            if let firstAired = showDictionary[Client.TraktParameters.FirstAired] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZZ"
                self.firstAired = dateFormatter.date(from: firstAired) as NSDate?
            }

            if let airs = showDictionary[Client.TraktParameters.Airs] as? [String:AnyObject] {

                if let airDay = airs[Client.TraktParameters.Day] {
                    self.airDay = airDay as? String
                }

                if let airTime = airs[Client.TraktParameters.Time] {
                    self.airTime = airTime as? String
                }

                if let timezone = airs[Client.TraktParameters.Timezone] {
                    self.timezone = timezone as? String
                }

            }

            if let runtime = showDictionary[Client.TraktParameters.Runtime] {
                self.runtime = runtime as! Int
            }

            if let network = showDictionary[Client.TraktParameters.Network] {
                self.network = network as? String
            }

            if let trailer = showDictionary[Client.TraktParameters.Trailer] {
                self.trailer = trailer as? String
            }

            if let status = showDictionary[Client.TraktParameters.Status] {
                self.status = status as? String
                self.status?.capitalizeFirstLetter()
            }

            if let rating = showDictionary[Client.TraktParameters.Rating] {
                self.rating = rating as! Int
            }

            if let genreList = showDictionary[Client.TraktParameters.Genre] {
                if let genreList = genreList as? NSArray {
                    for genre in genreList {
                        self.genreList.append(Genres(value: genre))
                    }
                }
            }

            if let airedEpisodeCount = showDictionary[Client.TraktParameters.AiredEpisodes] {
                self.airedEpisodeCount = airedEpisodeCount as! Int
            }

            if let images = showDictionary[Client.TraktParameters.Images] as? [String:AnyObject] {

                if let poster = images[Client.TraktParameters.Poster]?[Client.TraktParameters.Full] {
                    self.poster = poster as? String
                }

                if let banner = images[Client.TraktParameters.Banner]?[Client.TraktParameters.Full] {
                    self.banner = banner as? String
                }

                if let fanart = images[Client.TraktParameters.Fanart]?[Client.TraktParameters.Full] {
                    self.fanart = fanart as? String
                }

                if let thumb = images[Client.TraktParameters.Thumb]?[Client.TraktParameters.Full] {
                    self.thumb = thumb as? String
                }

            }

        }

    }

    static func showsFromResults(_ results: [[String:AnyObject]]) -> [Show] {

        var shows = [Show]()

        for result in results {
            shows.append(Show(dictionary: result))
        }

        return shows

    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
