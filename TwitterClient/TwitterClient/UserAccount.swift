//
//  UserAccount.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import SafariServices
import BDBOAuth1Manager


let kRequestTokenPath = "oauth/request_token"
let kRequestTokenMethod = "GET"
let kCallbackURL = "cpchitter://oauth"

let kAuthorizePath = "/oauth/authorize"
let kRequestTokenParam = "oauth_token"

let kAccessTokenPath = "oauth/access_token"
let kAccessTokenMethod = "POST"

class UserAccount {
    
    
    weak var presentingViewController : UIViewController?
    var successCompletionHandler : ((Void) -> Void)?
    var errorCompletionHandler : ((NSError) -> Void)?
    
    var svc : SFSafariViewController?
    var homeStream : UserStream!
    
    func loginUser(presentingViewController : UIViewController, success:@escaping((Void) -> Void), error: @escaping((NSError) -> Void)) {
        successCompletionHandler = success
        errorCompletionHandler = error
        self.presentingViewController = presentingViewController
        
        homeStream = UserStream()
        
        TwitterClient.sharedInstance.fetchRequestToken(withPath: kRequestTokenPath,
                                                        method: kRequestTokenMethod,
                                                        callbackURL: URL(string:kCallbackURL)!,
                                                        scope: nil,
                                                        success: { (requestToken) in
                                                            if let requestToken = requestToken {
                                                                self.openInSafariViewController(requestToken: requestToken.token)
                                                            } else {
                                                                self.errorCompletionHandler?(NSError(domain: "Got empty request token!", code: 0, userInfo: nil))
                                                            }
            }, failure: { (error )  in
                print(error)
               // self.errorCompletionHandler?(error)
        })
    }
    
    func openInSafariViewController(requestToken : String) {
        
        let authURL = TwitterClient.sharedInstance.baseURL!.absoluteString
        let fullURL = authURL + kAuthorizePath + "?\(kRequestTokenParam)=\(requestToken)"
        if let url = URL(string: fullURL) {
            // let url = URL(string:kCallbackURL)!;
            svc = SFSafariViewController(url: url)
            self.presentingViewController?.present(svc!, animated: true, completion: nil);
            // UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            self.errorCompletionHandler?(NSError(domain: "Error creating auth url!", code: 0, userInfo: nil))
        }
    }
    
    func receivedOauthToken(url: URL) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        // svc?.dismiss(animated: true, completion: nil);
        if let urlQuery = url.query {

        
            TwitterClient.sharedInstance.fetchAccessToken(withPath: kAccessTokenPath,
                                                      method: kAccessTokenMethod,
                                                      requestToken: BDBOAuth1Credential(queryString: urlQuery),
                                                      success: { (accessToken) in
                                                        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            }, failure: { (error )  in
                print(error)
                // self.errorCompletionHandler?(error)
            })
        }
    }
}
