//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

let kOAuthConsumerKey = "nmO81pxwghuFjAjSwIjCoBO9s"
let kOAuthConsumerSecret = "3TDgHVkIUnYN40DQwIwigo5iQk4xQhFSoeKbEZg9NdwPJWKsE8"
let kOAuthBaseURL  = "https://api.twitter.com"


class OAuthClient : BDBOAuth1SessionManager {
    
    
   static let sharedInstance = OAuthClient(baseURL: URL(string: kOAuthBaseURL)!, consumerKey: kOAuthConsumerKey, consumerSecret: kOAuthConsumerSecret)!;
    
}
