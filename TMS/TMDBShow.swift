//
//  TMDBShow.swift
//  TMS
//
//  Created by Pushkar Sharma on 19/02/2017.
//  Copyright © 2017 Chashmeet Singh. All rights reserved.
//

import RealmSwift

class TMDBShow: Object {
    
    dynamic var posterPath: String? = ""
    dynamic var popularity: Float = -1
    dynamic var id: Int = -1
    dynamic var backdropPath: String? = ""
    dynamic var voteAverage: Float = 0
    dynamic var overview: String? = ""
    dynamic var firstAirDate: String? = ""
    dynamic var originCountry: String? = ""
    dynamic var genreIds: Int = 0
    dynamic var originalLanguage: String? = ""
    dynamic var voteCount: Int = 0
    dynamic var name: String? = ""
    dynamic var originalName: String? = ""
    dynamic var totalResults: String? = ""
    dynamic var totalPages: String? = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(dictionary: [String:AnyObject]) {
        self.init()
        
        for(key,value) in dictionary {
            if let values = value as? NSArray {
                if let val = values.firstObject as? String {
                    self.setValue(val, forKey: key.underscoreToCamelCase)
                } else if let val = values.firstObject as? Int {
                    self.setValue(val, forKey: key.underscoreToCamelCase)
                }
                continue
            }
//            if key == Client.TmdbParameters.OriginCountry, let c = value as? [String] {
//                self.setValue(c.first, forKey: key.underscoreToCamelCase)
//                continue
//            }
            if key == Client.TmdbParameters.PosterPath || key == Client.TmdbParameters.BackdropPath, let path = value as? String{
                self.setValue(imageURLFromPath(path: path).absoluteString, forKey: key.underscoreToCamelCase)
                continue
            }
            self.setValue(value, forKey: key.underscoreToCamelCase)
        }
        
    }
    
    //    override func setValue(_ value: Any?, forKey key: String) {
    //
    //    }
    
    static func showsFromResults(_ results: [[String:AnyObject]]) -> [TMDBShow] {
        
        var shows = [TMDBShow]()
        
        for result in results {
            shows.append(TMDBShow(dictionary: result))
        }
        return shows
    }
    
    func imageURLFromPath(path: String) -> URL {
        
        var components = URLComponents()
        components.scheme = Client.Tmdb.APIScheme
        components.host = Client.Tmdb.ImageBaseURL
        components.path = Client.TmdbMethods.PosterImage + path
        components.queryItems = [URLQueryItem]()
        
        return components.url!
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
    
    var underscoreToCamelCase: String {
        let items = self.components(separatedBy: "_")
        var camelCase = ""
        items.enumerated().forEach {
            camelCase += 0 == $0 ? $1 : $1.capitalized
        }
        return camelCase
    }
}
