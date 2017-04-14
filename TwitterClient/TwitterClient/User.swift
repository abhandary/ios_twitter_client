//
//  User.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class User {
    
    var name : String?
    var screename : String?
    var profileURL : URL?
    var tagline : String?
    
    init(dictionary : [String : Any?]) {
        name = dictionary["name"] as? String
        screename = dictionary["screen_name"] as? String
        
        if let urlString = dictionary["profile_image_url_https"] as? String {
            profileURL = URL(string: urlString);
        }
        
        tagline = dictionary["description"] as? String
        
    }
}
