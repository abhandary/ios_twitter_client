//
//  UserAccount.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import SafariServices


class UserAccount {
    
    let loginService = UserLoginService()
    
    var successCompletionHandler : ((Void) -> Void)?
    var errorCompletionHandler : ((NSError) -> Void)?
    
    var svc : SFSafariViewController?
    var homeStream : UserStreamService!
    
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
    
    func receivedOauthToken(url: URL) {
        self.loginService.receivedOauthToken(url: url)
    }
}

