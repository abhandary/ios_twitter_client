//
//  UserAccount.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import SafariServices


@objc protocol UserAccountDelegate {
    func receivedRequestToken(url : URL);
}

class UserAccount {
    
    weak var delegate : UserAccountDelegate?
    
    let loginService = UserLoginService()
    
    var successCompletionHandler : ((Void) -> Void)?
    var errorCompletionHandler : ((NSError) -> Void)?
    
    var svc : SFSafariViewController?
    var homeStream : UserStreamService!
    
    func loginUser(success:@escaping((Void) -> Void), error: @escaping((NSError) -> Void)) {
        successCompletionHandler = success
        errorCompletionHandler = error
        
        // homeStream = UserStreamService()
        
        loginService.delegate = self
        loginService.loginUser(success: { () in
                self.successCompletionHandler?()
            }) { (error) in
                
        }
        
    }
    
    func receivedOauthToken(url: URL) {
        self.loginService.receivedOauthToken(url: url)
    }
}

extension UserAccount : UserLoginServiceDelegate {
    
    func receivedRequestToken(url: URL) {
        self.delegate?.receivedRequestToken(url: url)
    }
    
}
