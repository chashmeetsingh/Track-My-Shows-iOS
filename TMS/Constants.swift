//
//  Constants.swift
//  TMS
//
//  Created by Y50 on 26/09/16.
//  Copyright © 2016 Chashmeet Singh. All rights reserved.
//

import Foundation

extension Client {
    
    struct Trakt {
        static let APIScheme = "https"
        static let BaseURL = "api.trakt.tv"
    }
    
    struct TracktHeadersParamters {
        static let ContentType = "Content-Type"
        static let API_VERSION = "trakt-api-version"
        static let APIKey = "trakt-api-key"
    }
    
    struct TraktHeaderValues {
        static let ContentType = "application/json"
        static let API_VERSION = 2
        static let APIKey = "82d121bb47a5b9ff718a52e9671e0aec9ab425ace578a791efc42bdf247ff3bb"
    }
    
    struct TraktParameters {
        static let Show = "show"
        static let Title = "title"
        static let Year = "year"
        static let IDS = "ids"
        static let TraktID = "trakt"
        static let Overview = "overview"
        static let FirstAired = "first_aired"
        static let Airs = "airs"
        static let Day = "day"
        static let Time = "time"
        static let Timezone = "timezone"
        static let Runtime = "runtime"
        static let Network = "network"
        static let Trailer = "trailer"
        static let Status = "status"
        static let Rating = "rating"
        static let Genre = "genre"
        static let AiredEpisodes = "aired_episodes"
        static let Images = "images"
        static let Fanart = "fanart"
        static let Poster = "poster"
        static let Banner = "banner"
        static let Thumb = "thumb"
        static let Medium = "medium"
        static let Episodes = "episodes"
        static let EpisodeCount = "episode_count"
        static let SeasonNumber = "season"
        static let ScreenShot = "screenshot"
        static let Number = "number"
        static let Votes = "votes"
    }
    
    struct MyAPI {
        static let APIScheme = "http"
        static let BaseUrl = "139.59.6.0"
    }
    
    struct MyAPIResponseKeys {
        static let Results = "results"
        static let Response = "response"
        static let Overview = "overview"
        static let Poster = "poster"
        static let Title = "title"
        static let Status = "status"
        static let Thumb = "thumb"
        static let TraktID = "trakt_id"
        static let TvdbID = "tvdb_id"
        static let watchers = "watchers"
        static let Year = "year"
        static let Actors = "actors"
        static let AirTime = "air_time"
        static let Banner = "banner"
        static let Fanart = "fanart"
        static let FirstAired = "first_aired"
        static let Genre = "genre"
        static let showID = "id"
        static let Network = "network"
        static let Rating = "rating"
        static let RatingCount = "rating_count"
        static let Runtime = "runtime"
        static let Timezone = "timezone"
        static let AirDateTime = "air_date_time"
        static let Image = "image"
        static let EpisodeNo = "episode"
        static let SeasonNo = "season"
        static let Writer = "writer"
        static let Episodes = "episodes"
        static let Seasons = "seasons"
        static let EpisodeID = "id"
        static let Watched = "watched"
    }
    
    struct TVDB {
        static let BaseUrl = "http://thetvdb.com/"
    }
    
    struct TVDBParamterKeys {
        static let API_KEY = "api_key"
    }
    
    struct TVDBParameterValues {
        static let APIKEY = "22D2AFEE650432D3"
    }
}
