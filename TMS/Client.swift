//
//  Client.swift
//  TMS
//
//  Created by Y50 on 26/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import Foundation

class Client: NSObject {

    var session: URLSession
    static let sharedInstance = Client()

    private override init() {
        session = URLSession.shared
        super.init()
    }

    // MARK: GET Methods
    func taskForGETMethod(useTmdb: Bool = false, method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        /* 1. Set the parameters */
        var parameters = parameters

        /* 2/3. Build the URL, Configure the request */
        var request: URLRequest!
        if (!useTmdb) {
            request = URLRequest(url: myAPIURLFromParameters(parameters: parameters, withPathExtension: method))
            request.addValue(Client.TraktHeaderValues.APIKey, forHTTPHeaderField: Client.TraktHeadersParamters.APIKey)
            request.addValue(Client.TraktHeaderValues.API_VERSION, forHTTPHeaderField: Client.TraktHeadersParamters.API_VERSION)
            request.addValue(Client.TraktHeaderValues.ContentType, forHTTPHeaderField: Client.TraktHeadersParamters.ContentType)
        } else {
            request = URLRequest(url: tmdbURLFromParameters(parameters: parameters, withPathExtension: method))
        }
        /* 4. Make the request */
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in

            func sendError(_ error: String) {

                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.parseJSONWithCompletionHandler(data, completionHandler: completionHandlerForGET)
        })

        /* 7. Start the request */
        task.resume()

        return task
    }



    // MARK: Helper Methods
    private func escapedParameters(_ parameters: [String : AnyObject]) -> String {

        var urlVars = [String]()

        for (key, value) in parameters {

            /* Make sure that it is a string value */
            let stringValue = "\(value)"

            /* Escape it */
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]

        }

        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }

    /* Parsing JSON */
    private func parseJSONWithCompletionHandler(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {

        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }

        completionHandler(parsedResult as AnyObject?, nil)
    }

    // create a URL from parameters
    func myAPIURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {

        var components = URLComponents()
        components.scheme = Client.Trakt.APIScheme
        components.host = Client.Trakt.BaseURL
        components.path = withPathExtension ?? ""
        components.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }

        return components.url!
    }
    
    func tmdbURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Client.Tmdb.APIScheme
        components.host = Client.Tmdb.BaseURL
        components.path = withPathExtension ?? ""
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

}
