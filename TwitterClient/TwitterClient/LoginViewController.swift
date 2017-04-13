//
//  ViewController.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
    let user = UserAccountManager.createUser()
        user.loginUser(presentingViewController:self,
                       success: { () in
            print("success");
        }) { (error) in
            print(error)
        }
        
    }
    
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue) {
        
    }
}

