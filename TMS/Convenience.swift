//
//  Convenience.swift
//  TMS
//
//  Created by Y50 on 26/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension Client {
    
    func getTrendingShows(completionHandlerForGetTrendingShows: (data: [Show]?,success: Bool, error: NSError?) -> Void) {
        
        let methodParameters = [
            Client.TVDBParamterKeys.API_KEY: Client.TVDBParameterValues.APIKEY
        ]
        
        taskForPOSTMethod(Client.MyAPI.BaseUrl, method: "/trending", parameters: methodParameters, completionHandlerForPOST: { (result, error) in
            
            if error != nil {
                
                completionHandlerForGetTrendingShows(data: nil, success: false, error: error)
            } else {
                guard let response = result[Client.MyAPIResponseKeys.Response] else {
                    completionHandlerForGetTrendingShows(data: nil, success: false, error: NSError(domain: "ParseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse trendingShows"]))
                    return
                }
                
                let shows = Show.showsFromResults(response as! [[String : AnyObject]])
                self.shows = shows
                completionHandlerForGetTrendingShows(data: shows, success: true, error: nil)
            }
            
        })
        
    }
    
    func getShowData(show: Show, completionHandlerForGETShowData: (data: Show?, success: Bool, error: NSError?) -> Void) {
        
        let methodParameters = [
            Client.TVDBParamterKeys.API_KEY: Client.TVDBParameterValues.APIKEY
        ]
        
        taskForPOSTMethod(Client.MyAPI.BaseUrl, method: "/show/id/\(show.tvdbID)/\(show.traktID)", parameters: methodParameters, completionHandlerForPOST: { ( result, error) in
            if error != nil {
                completionHandlerForGETShowData(data: nil, success: false, error: error)
            } else {
                var result = result as! [String:AnyObject]
                result[Client.MyAPIResponseKeys.TvdbID] = show.tvdbID
                result[Client.MyAPIResponseKeys.TraktID] = show.traktID
                result[Client.MyAPIResponseKeys.Thumb] = show.thumb
                let show = Show.getShowFromResult(result)
                
                performDatabaseOperations({
                    let realm = try! Realm()
                    try! realm.write() {
                        realm.add(show, update: true)
                    }
                })
                
                completionHandlerForGETShowData(data: show, success: true, error: nil)
            }
        })
        
    }
    
}