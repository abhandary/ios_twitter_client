//
//  UserStream.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


let kHomeTimeLine = "1.1/statuses/home_timeline.json"
let kVerifyCredentials = "1.1/account/verify_credentials.json"

class UserTimeLineService {
    
    var timeLine = kHomeTimeLine
    
    
    
    func fetchTweets(success: @escaping (([Tweet]) -> Void),
                     error:@escaping ((Error) -> Void)) {
        
        OAuthClient.sharedInstance.get(timeLine,
                                       parameters: nil,
                                       progress: nil,
                                       success: { (task, response) in
                                            if let dictionaries = response as? [[String : Any]] {
                                                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries);
                                                success(tweets)
                                            } else {
                                                error(NSError(domain: "unable to fetcht tweets", code: 0, userInfo: nil))
                                            }
            }) { (task, receivedError) in
                error(receivedError)
        }
    }
    
    func currentUser(success : @escaping (User) -> (), error : @escaping (Error) -> ()) {
        
        OAuthClient.sharedInstance.get(kVerifyCredentials,
                                       parameters: nil,
                                       progress: nil,
                                       success: { (task, response) in
                                        if let dictionary = response as? [String : Any] {
                                            let user = User(dictionary: dictionary)
                                            success(user)
                                        } else {
                                            error(NSError(domain: "unable to fetch user", code: 0, userInfo: nil))
                                        }
        }) { (task, receivedError) in
            error(receivedError)
        }
    }
    
}
