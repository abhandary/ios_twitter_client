//
//  UserStream.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


let kHomeTimeLine      = "1.1/statuses/home_timeline.json"
let kVerifyCredentials = "1.1/account/verify_credentials.json"
let kPostStatusUpdate  = "1.1/statuses/update.json"



let kCountParam = "count"
let kMaxIDParam = "max_id"

class UserTimeLineService {
    
    var timeLine = kHomeTimeLine
    
    let kMaxTweetCountPerRequest = 20 // @note: can go upto 200
    
    var lastSeenLowestTweetID = Int.max
    
    var tweetsLoading = false
    
    // MARK:- public routines
    func fetchTweets(success: @escaping (([Tweet]) -> Void),
                     error:@escaping ((Error) -> Void)) {
        
        let params = [kCountParam : kMaxTweetCountPerRequest]
        fetchTweets(params: params, success: success, error: error)
    }
    
    func fetchTweetsOlderThanLastFetch(success: @escaping (([Tweet]) -> Void),
                                       error:@escaping ((Error) -> Void)) {
        
        guard lastSeenLowestTweetID < Int.max else {
            error(NSError(domain: "no more tweets available", code: 0, userInfo: nil));
            return;
        }
        
        let params = [
                      kCountParam : kMaxTweetCountPerRequest,
                      kMaxIDParam :lastSeenLowestTweetID
                      ]
        fetchTweets(params: params, success: success, error: error)
    }
    
    
    func currentUser(success : @escaping (User) -> (), error : @escaping (Error) -> ()) {
        
        OAuthClient.sharedInstance.get(kVerifyCredentials,
                                       parameters: nil,
                                       progress: nil,
                                       success: { (task, response) in
                                        if let dictionary = response as? NSDictionary {
                                            let user = User(dictionary: dictionary)
                                            success(user)
                                        } else {
                                            error(NSError(domain: "unable to fetch user", code: 0, userInfo: nil))
                                        }
        }) { (task, receivedError) in
            error(receivedError)
        }
    }
    
    func post(statusUpdate : StatusUpdate, success : @escaping (Tweet) -> (), error : @escaping (Error) -> ()) {
        guard statusUpdate.tweetText != nil else {
            error(NSError(domain: "bad status text", code: 0, userInfo: nil))
            return;
        }
        let params = ["status" : statusUpdate.tweetText!]
        postStatusUpdate(params: params, success: success, error: error)
    }
    
    
    // MARK: - internal tweets
    
    internal func postStatusUpdate(params : [String : Any], success : @escaping (Tweet) -> (), error : @escaping (Error) -> ()) {
        
        OAuthClient.sharedInstance.post(kPostStatusUpdate,
                                       parameters: params,
                                       progress: nil,
                                       success: { (task, response) in
                                        print(response)
                                        if let dictionary = response as? NSDictionary {
                                            let tweet = Tweet(dictionary: dictionary);
                                            success(tweet)
                                        } else {
                                            error(NSError(domain: "unable to post tweet", code: 0, userInfo: nil))
                                        }
        }) { (task, receivedError) in
            error(receivedError)
        }
    }
    
    internal func fetchTweets(params : [String : Any], success: @escaping (([Tweet]) -> Void),
                     error:@escaping ((Error) -> Void)) {
        
        
        OAuthClient.sharedInstance.get(timeLine,
                                       parameters: params,
                                       progress: nil,
                                       success: { (task, response) in
                                        if let dictionaries = response as? [NSDictionary] {
                                            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries);
                                            self.saveLastSeenLowestTweetID(tweets: tweets)
                                            success(tweets)
                                        } else {
                                            error(NSError(domain: "unable to fetcht tweets", code: 0, userInfo: nil))
                                        }
        }) { (task, receivedError) in
            error(receivedError)
        }
    }

    
    internal func saveLastSeenLowestTweetID(tweets : [Tweet]) {
        lastSeenLowestTweetID = Int.max
        tweets.forEach { (tweet) in
            if let tweetID = tweet.tweetID {
                lastSeenLowestTweetID = min(tweetID, lastSeenLowestTweetID)
            }
        }
    }
    
}
