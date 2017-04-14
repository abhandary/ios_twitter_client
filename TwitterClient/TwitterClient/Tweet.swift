//
//  Tweet.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class Tweet {
    var text : String?
    var timestamp : Date?
    var retweetCount : Int?
    var favoritesCount : Int?
    
    static let dateFormatter = DateFormatter()
    
    init(dictionary : [String : Any?]) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            
            Tweet.dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = Tweet.dateFormatter.date(from: timestampString)
        }
    }
    
    static func tweetsWithArray(dictionaries: [[String : Any?]]) -> [Tweet] {
        return dictionaries.map { Tweet(dictionary: $0) }
    }
}
