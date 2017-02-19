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

    func getTrendingShows(_ completionHandlerForGetTrendingShows: @escaping (_ data: [TMDBShow]?, _ success: Bool, _ error: NSError?) -> Void) {

        let methodParameters = [
//            Client.TraktMethodKeys.Extended: Client.TraktMethodValues.FullImages,
//            Client.TraktMethodKeys.Limit: Client.TraktMethodValues.Limit
            TmdbMethodKeys.APIKey : Tmdb.APIKey
        ]

        _ = taskForGETMethod(useTmdb: true, method: TmdbMethods.PopularTV, parameters: methodParameters as [String : AnyObject], completionHandlerForGET: { (result, error) in

            if error != nil {
                completionHandlerForGetTrendingShows(nil, false, error)
            } else {
                guard let response = result else {
                    completionHandlerForGetTrendingShows(nil, false, NSError(domain: "ParseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse trendingShows"]))
                    return
                }
                var shows: [TMDBShow]? = nil
                if let results = response[TmdbParameters.Results] {
                    shows = TMDBShow.showsFromResults(results as! [[String : AnyObject]])
                }

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

    func getShowsByName(_ showName: String, completionHandlerForGETShowByName: @escaping (_ shows: [Show]?, _ success: Bool, _ error: NSError?) -> Void) {

        let queryString = showName.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.literal, range: nil)
        
        let methodParameters = [
            Client.TraktMethodKeys.Extended: Client.TraktMethodValues.FullEpisodes,
            Client.TraktMethodKeys.Query: queryString
        ]


        _ = taskForGETMethod(method: "/search/show", parameters: methodParameters as [String : AnyObject], completionHandlerForGET: { ( result, error) in
            if error != nil {
                completionHandlerForGETShowByName(nil, false, error)
            } else {
                guard let response = result else {
                    completionHandlerForGETShowByName(nil, false, NSError(domain: "ParseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse show search by name"]))
                    return
                }

                let shows = Show.showsFromResults(response as! [[String : AnyObject]])

                completionHandlerForGETShowByName(shows, true, nil)

            }
        })

    }

}
