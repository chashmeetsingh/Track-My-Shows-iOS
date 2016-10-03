//
//  Episode.swift
//  TMS
//
//  Created by Y50 on 28/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import RealmSwift

class Episode: Object {

    dynamic var number: Int = -1
    dynamic var title: String? = "Not Available"
    dynamic var id: Int = -1
    dynamic var overview: String? = "Not Available"
    dynamic var rating: Double = 0.0
    dynamic var votes: Int = 0
    dynamic var firstAired: NSDate?
    dynamic var image: String? = ""
    dynamic var watched: Bool = false
    dynamic var season: Season!

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(dictionary: [String:AnyObject]) {
        self.init()

        if let number = dictionary[Client.TraktParameters.Number] as? Int {
            self.number = number
        }

        if let title = dictionary[Client.TraktParameters.Title] as? String {
            self.title = title
        }

        if let ids = dictionary[Client.TraktParameters.IDS] {
            if let id = ids[Client.TraktParameters.TraktID] as? Int {
                self.id = id
            }
        }

        if let overview = dictionary[Client.TraktParameters.Overview] as? String {
            self.overview = overview
        }

        if let rating = dictionary[Client.TraktParameters.Rating] as? Double {
            self.rating = rating
        }

        if let votes = dictionary[Client.TraktParameters.Votes] as? Int {
            self.votes = votes
        }

        if let firstAired = dictionary[Client.TraktParameters.FirstAired] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
            self.firstAired = dateFormatter.date(from: firstAired) as NSDate?
        }

        if let images = dictionary[Client.TraktParameters.Images] as? [String:AnyObject] {

            if let image = images[Client.TraktParameters.ScreenShot]?[Client.TraktParameters.Full] as? String {
                self.image = image
            }

        }

    }

    static func getEpisodesFromResult(_ season: Season, results: [[String:AnyObject]]) -> List<Episode> {

        let episodes = List<Episode>()

        for result in results {
            let episode = Episode(dictionary: result)
            episode.season = season
            episodes.append(episode)
        }

        return episodes

    }

}
