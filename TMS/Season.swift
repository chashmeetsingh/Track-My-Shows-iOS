//
//  Season.swift
//  TMS
//
//  Created by Y50 on 02/10/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import RealmSwift

class Season: Object {

    dynamic var number: Int = -1
    dynamic var id: Int = -1
    dynamic var rating: Double = 0.0
    dynamic var votes: Int = 0
    dynamic var poster: String?
    dynamic var thumb: String?
    var show: Show!
    var episodes = List<Episode>()

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(dictionary: [String:AnyObject]) {
        self.init()

        if let number = dictionary[Client.TraktParameters.Number] {
            self.number = number as! Int
        }

        if let ids = dictionary[Client.TraktParameters.IDS] {
            if let id = ids[Client.TraktParameters.TraktID] {
                self.id = id as! Int
            }
        }

        if let rating = dictionary[Client.TraktParameters.Rating] {
            self.rating = rating as! Double
        }

        if let votes = dictionary[Client.TraktParameters.Votes] {
            self.votes = votes as! Int
        }

        if let images = dictionary[Client.TraktParameters.Images] as? [String:AnyObject] {

            if let poster = images[Client.TraktParameters.Poster]?[Client.TraktParameters.Full] {
                self.poster = poster as? String
            }

            if let thumb = images[Client.TraktParameters.Thumb]?[Client.TraktParameters.Full] {
                self.thumb = thumb as? String
            }

        }

    }

    static func getSeasonFromResult(_ show: Show, results: [[String:AnyObject]]) -> List<Season> {

        let seasons = List<Season>()

        for result in results {
            let season = Season(dictionary: result)
            season.show = show

            season.episodes = Episode.getEpisodesFromResult(season, results: result[Client.TraktParameters.Episodes] as! [[String:AnyObject]])

            seasons.append(season)
        }

        return seasons

    }

}
