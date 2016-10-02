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

    func getTrendingShows(_ completionHandlerForGetTrendingShows: @escaping (_ data: [Show]?, _ success: Bool, _ error: NSError?) -> Void) {

        let methodParameters = [
            Client.TraktMethodKeys.Extended: Client.TraktMethodValues.FullImages,
            Client.TraktMethodKeys.Limit: Client.TraktMethodValues.Limit
        ]

        _ = taskForGETMethod(method: "/shows/trending", parameters: methodParameters as [String : AnyObject], completionHandlerForGET: { (result, error) in

            if error != nil {

                completionHandlerForGetTrendingShows(nil, false, error)
            } else {
                guard let response = result else {
                    completionHandlerForGetTrendingShows(nil, false, NSError(domain: "ParseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse trendingShows"]))
                    return
                }

                let shows = Show.showsFromResults(response as! [[String : AnyObject]])

                completionHandlerForGetTrendingShows(shows, true, nil)
            }

        })

    }

    func getSeasons(_ show: Show, completionHandlerForGETShowData: @escaping (_ success: Bool, _ error: NSError?) -> Void) {

        let methodParameters = [
            Client.TraktMethodKeys.Extended: Client.TraktMethodValues.FullEpisodes
        ]

         _ = taskForGETMethod(method: "/shows/\(show.id)/seasons", parameters: methodParameters as [String : AnyObject], completionHandlerForGET: { ( result, error) in
            if error != nil {
                completionHandlerForGETShowData(false, error)
            } else {

                show.seasons = Season.getSeasonFromResult(show, results: result as! [[String : AnyObject]])

                performDatabaseOperations({
                    let realm = try! Realm()

                    do {
                        try realm.write() {
                            realm.add(show, update: true)
                        }
                        completionHandlerForGETShowData(true, nil)
                    } catch let error {
                        completionHandlerForGETShowData(false, NSError(domain: "\(error.localizedDescription)", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not save show"]))
                    }
                })

                completionHandlerForGETShowData(true, nil)

            }
        })

    }

//    func getShowsByName(_ showName: String, completionHandlerForGETShowByName: @escaping (_ shows: [Show]?, _ success: Bool, _ error: NSError?) -> Void) {

//
//        let queryString = showName.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.literal, range: nil)
//
//        _ = taskForPOSTMethod(Client.MyAPI.BaseUrl, method: "/show/name/\(queryString)", parameters: methodParameters as [String : AnyObject], completionHandlerForPOST: { ( result, error) in
//            if error != nil {
//                completionHandlerForGETShowByName(nil, false, error)
//            } else {
//                guard let response = result?[Client.MyAPIResponseKeys.Results] else {
//                    completionHandlerForGETShowByName(nil, false, NSError(domain: "ParseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse show search by name"]))
//                    return
//                }
//
//                let shows = Show.showsFromResults(response as! [[String : AnyObject]])
//
//                completionHandlerForGETShowByName(shows, true, nil)
//
//            }
//        })
//
//    }

}
