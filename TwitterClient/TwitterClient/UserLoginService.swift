//
//  UserLoginService.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

import BDBOAuth1Manager


let kRequestTokenPath = "oauth/request_token"
let kRequestTokenMethod = "GET"
let kCallbackURL = "cpchitter://oauth"

let kAuthorizePath = "/oauth/authorize"
let kRequestTokenParam = "oauth_token"

let kAccessTokenPath = "oauth/access_token"
let kAccessTokenMethod = "POST"


@objc protocol UserLoginServiceDelegate {
    func receivedRequestToken(url : URL);
}

class UserLoginService {
    
    weak var delegate: UserLoginServiceDelegate?
    
    var errorCompletionHandler : ((NSError) -> Void)?
    var successCompletionHandler: ((Void) -> Void)?
    
    // MARK: - public routines
    func loginUser(success:@escaping((Void) -> Void), error: @escaping((NSError) -> Void)) {
        
        self.errorCompletionHandler = error
        self.successCompletionHandler = success
        
        OAuthClient.sharedInstance.fetchRequestToken(withPath: kRequestTokenPath,
                                                       method: kRequestTokenMethod,
                                                       callbackURL: URL(string:kCallbackURL)!,
                                                       scope: nil,
                                                       success: { (requestToken) in
                                                        if let requestToken = requestToken {
                                                            self.received(requestToken: requestToken.token)
                                                        } else {
                                                            self.errorCompletionHandler?(NSError(domain: "Got empty request token!", code: 0, userInfo: nil))
                                                        }
            }, failure: { (error )  in
                print(error)
                // self.errorCompletionHandler?(error)
        })
        
    }
    
    
    func receivedOauthToken(url: URL) {
        
        if let urlQuery = url.query {
            
            OAuthClient.sharedInstance.fetchAccessToken(withPath: kAccessTokenPath,
                                                          method: kAccessTokenMethod,
                                                          requestToken: BDBOAuth1Credential(queryString: urlQuery),
                                                          success: { (accessToken) in
                                                            OAuthClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                                                            self.successCompletionHandler?()
                                                            
                }, failure: { (error )  in
                    print(error)
                    // self.errorCompletionHandler?(error)
            })
            
        }

    }
    
    
    
    internal func received(requestToken : String) {
        let authURL = OAuthClient.sharedInstance.baseURL!.absoluteString
        let fullURL = authURL + kAuthorizePath + "?\(kRequestTokenParam)=\(requestToken)"
        if let url = URL(string: fullURL) {
            self.delegate?.receivedRequestToken(url: url)
        } else {
            self.errorCompletionHandler?(NSError(domain: "Unable to form authorize URL", code: 0, userInfo: nil))
        }
    }
    
    
    
}
