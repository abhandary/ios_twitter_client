//
//  UserStream.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


let kHomeTimeLine = "1.1/statuses/home_timeline.json"

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
                                                error(NSError(domain: "bad response", code: 0, userInfo: nil))
                                            }
            }) { (task, receivedError) in
                error(receivedError)
        }
    }
    
    
}
