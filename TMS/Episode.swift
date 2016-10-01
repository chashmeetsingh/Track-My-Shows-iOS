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
    dynamic var title: String?
    dynamic var id: Int = -1
    dynamic var overview: String?
    var rating: Double? = 0.0
    var votes: Int? = 0
    dynamic var firstAired: NSDate?
    dynamic var image: String?
    dynamic var season: Season!
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(dictionary: [String:AnyObject]) {
        self.init()
        
        if let number = dictionary[Client.TraktParameters.Number] {
            self.number = number as! Int
        }
        
        if let title = dictionary[Client.TraktParameters.Title] {
            self.title = title as? String
        }
        
        if let id = dictionary[Client.TraktParameters.TraktID] {
            self.id = id as! Int
        }
        
        if let overview = dictionary[Client.TraktParameters.Overview] {
            self.overview = overview as? String
        }
        
        if let rating = dictionary[Client.TraktParameters.Rating] {
            self.rating = rating as? Double
        }
        
        if let votes = dictionary[Client.TraktParameters.Votes] {
            self.votes = votes as? Int
        }
        
        if let firstAired = dictionary[Client.TraktParameters.FirstAired] {
            self.firstAired = firstAired as? NSDate
        }
        
        if let image = dictionary[Client.TraktParameters.ScreenShot]{
            self.image = image as? String
        }
        
    }
    
}
