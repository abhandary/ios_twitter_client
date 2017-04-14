//
//  UserAccount.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class UserAccount {
    
    let loginService = UserLoginService()
    var homeTimeLineService = UserTimeLineService()
    
    var successCompletionHandler : ((Void) -> Void)?
    var errorCompletionHandler : ((NSError) -> Void)?
    

    // MARK: - public routines
    
    func loginUser(success:@escaping((Void) -> Void),
                   error: @escaping((NSError) -> Void),
                   receivedRequestToken: @escaping((URL) -> Void)) {
        
        successCompletionHandler = success
        errorCompletionHandler = error
        
        // homeStream = UserStreamService()
        
        loginService.loginUser(success: { () in

            self.successCompletionHandler?()
            }, error: { (error) in
                
            }, receivedRequestToken: { (url) in
                receivedRequestToken(url)
        })
        
    }
    
    func receivedOauthToken(url: URL, success: @escaping ((Void)->Void), error:@escaping ((Error)->Void)) {
        self.loginService.receivedOauthToken(url: url, success: success, error: error)
    }
    
    func fetchTweets(success: @escaping (([Tweet]) -> Void),
                     error:@escaping ((Error) -> Void)) {
        
        homeTimeLineService.fetchTweets(success: success, error: error)
    }
}

