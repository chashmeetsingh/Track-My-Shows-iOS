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
    var rating: Double? = 0.0
    var votes: Int? = 0
    dynamic var poster: String?
    dynamic var thumb: String?
    var show: Show!
    var episodes = List<Episode>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(dictionary: [String:AnyObject]) {
        self.init()
        
        if let number = dictionary[Client.TraktParameters.SeasonNumber] {
            self.number = number as! Int
        }
        
        if let id = dictionary[Client.TraktParameters.TraktID] {
            self.id = id as! Int
        }
        
        if let rating = dictionary[Client.TraktParameters.Rating] {
            self.rating = rating as? Double
        }
        
        if let votes = dictionary[Client.TraktParameters.Votes] {
            self.votes = votes as? Int
        }
        
        if let poster = dictionary[Client.TraktParameters.Poster] {
            self.poster = poster as? String
        }
        
        if let thumb = dictionary[Client.TraktParameters.Thumb] {
            self.thumb = thumb as? String
        }
        
    }
    
}
