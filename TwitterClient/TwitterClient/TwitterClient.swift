//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

let kTwitterConsumerKey = "nmO81pxwghuFjAjSwIjCoBO9s"
let kTwitterConsumerSecret = "3TDgHVkIUnYN40DQwIwigo5iQk4xQhFSoeKbEZg9NdwPJWKsE8"
let kTwitterBaseURL  = "https://api.twitter.com"


class TwitterClient : BDBOAuth1SessionManager {
    
    
   static let sharedInstance = TwitterClient(baseURL: URL(string: kTwitterBaseURL)!, consumerKey: kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)!;
    
}
