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
    
    func getTrendingShows(_ completionHandlerForGetTrendingShows: @escaping (_ data: [Show]?,_ success: Bool, _ error: NSError?) -> Void) {
        
        let methodParameters = [
            Client.TVDBParamterKeys.API_KEY: Client.TVDBParameterValues.APIKEY
        ]
        
        _ = taskForPOSTMethod(Client.MyAPI.BaseUrl, method: "/trending", parameters: methodParameters as [String : AnyObject], completionHandlerForPOST: { (result, error) in
            
            if error != nil {
                
                completionHandlerForGetTrendingShows(nil, false, error)
            } else {
                guard let response = result?[Client.MyAPIResponseKeys.Response] else {
                    completionHandlerForGetTrendingShows(nil, false, NSError(domain: "ParseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse trendingShows"]))
                    return
                }
                
                let shows = Show.showsFromResults(response as! [[String : AnyObject]])
                self.shows = shows
                completionHandlerForGetTrendingShows(shows, true, nil)
            }
            
        })
        
    }
    
    func getShowData(_ show: Show, completionHandlerForGETShowData: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let methodParameters = [
            Client.TVDBParamterKeys.API_KEY: Client.TVDBParameterValues.APIKEY
        ]
        
         _ = taskForPOSTMethod(Client.MyAPI.BaseUrl, method: "/show/id/\(show.tvdbID)/\(show.traktID)", parameters: methodParameters as [String : AnyObject], completionHandlerForPOST: { ( result, error) in
            if error != nil {
                completionHandlerForGETShowData(false, error)
            } else {
                var result = result as! [String:AnyObject]
                result[Client.MyAPIResponseKeys.TvdbID] = show.tvdbID as AnyObject?
                result[Client.MyAPIResponseKeys.TraktID] = show.traktID as AnyObject?
                result[Client.MyAPIResponseKeys.Thumb] = show.thumb as AnyObject?
                let show = Show.getShowFromResult(result)
                
                performDatabaseOperations({
                    let realm = try! Realm()
                    
                    do {
                        try realm.write() {
                            realm.add(show, update: true)
                        }
                        completionHandlerForGETShowData(true, nil)
                    } catch let error {
                        completionHandlerForGETShowData(false , NSError(domain: "Error: \(error)", code: -1, userInfo: [:]))
                    }
                })
                
                
            }
        })
        
    }
    
    func getShowsByName(_ showName: String, completionHandlerForGETShowByName: @escaping (_ shows: [Show]?, _ success: Bool, _ error: NSError?) -> Void) {
        
        let methodParameters = [
            Client.TVDBParamterKeys.API_KEY: Client.TVDBParameterValues.APIKEY
        ]
        
        let queryString = showName.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.literal, range: nil)
        
        _ = taskForPOSTMethod(Client.MyAPI.BaseUrl, method: "/show/name/\(queryString)", parameters: methodParameters as [String : AnyObject], completionHandlerForPOST: { ( result, error) in
            if error != nil {
                completionHandlerForGETShowByName(nil, false, error)
            } else {
                guard let response = result?[Client.MyAPIResponseKeys.Results] else {
                    completionHandlerForGETShowByName(nil, false, NSError(domain: "ParseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse show search by name"]))
                    return
                }
                
                let shows = Show.showsFromResults(response as! [[String : AnyObject]])
                
                completionHandlerForGETShowByName(shows, true, nil)
                
            }
        })
        
    }
    
}
