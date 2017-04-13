//
//  UserAccountManager.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class UserAccountManager {
    
    var userAccounts : [UserAccount] = []
    
    let serialQueue = DispatchQueue(label: "UserAccountManager.Queue")
    
    static let sharedInstance = UserAccountManager()
    
    static func createUser() -> UserAccount {
        let user = UserAccount()
        sharedInstance.addUserAccount(user: user)
        return user;
    }
    
    func addUserAccount(user : UserAccount) {
        serialQueue.async {
            self.userAccounts.append(user)
        }
    }
    
    static func currentUser() -> UserAccount? {
        return sharedInstance.currentUser()
    }
    
    func currentUser() -> UserAccount? {
        var user : UserAccount? = nil
        serialQueue.sync {
            if self.userAccounts.count > 0 {
                user = self.userAccounts[0];
            }
        }
        return user;
    }
}
