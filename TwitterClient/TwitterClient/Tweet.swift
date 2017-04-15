//
//  Tweet.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class Tweet {
    
    var tweetID : Int?
    var text : String?
    var timestamp : Date?
    var retweetCount : Int?
    var favoritesCount : Int?
    
    var retweeted : Bool?
    
    var user : User?
    
    static let dateFormatter = DateFormatter()
    
    init(dictionary : NSDictionary) {

        print(dictionary)
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            
            Tweet.dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = Tweet.dateFormatter.date(from: timestampString)
        }
        
        if let userDict = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDict)
        }
        
        if let id = dictionary["id"] as? Int {
            tweetID = id
        }
        
    }
    
    static func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        return dictionaries.map { Tweet(dictionary: $0) }
    }
}
