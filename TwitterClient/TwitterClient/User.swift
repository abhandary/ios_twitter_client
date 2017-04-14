 //
//  User.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

let kCurrentUserData = "kCurrentUserData"

class User  {
    
    var name : String?
    var screename : String?
    var profileURL : URL?
    var tagline : String?
    
    var dictionary : [String : Any]?
    
    init(dictionary : [String : Any?]) {
        name = dictionary["name"] as? String
        screename = dictionary["screen_name"] as? String
        
        if let urlString = dictionary["profile_image_url_https"] as? String {
            profileURL = URL(string: urlString);
        }
        
        tagline = dictionary["description"] as? String
        
        self.dictionary = dictionary
    }
 
    internal static var _currentUser : User?
    static var currentUser : User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: kCurrentUserData)
                
                if let userData = userData as? Data {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any];
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            let defaults = UserDefaults.standard
            _currentUser = user
            if _currentUser == nil {
                defaults.removeObject(forKey: kCurrentUserData)
            } else {
                
                let json = try! JSONSerialization.data(withJSONObject: _currentUser?.dictionary!, options: JSONSerialization.WritingOptions.prettyPrinted)
                defaults.set(json, forKey: kCurrentUserData)
            }
            
        }
    }
    
 }
