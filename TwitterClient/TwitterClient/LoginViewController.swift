//
//  ViewController.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    let kShowUserTimeLineSegue = "showUserTimeLineSegue"
    
    var svc : SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        

        UserAccount.currentUserAccount?.loginUser(success: { () in
            
                if let svc = self.svc {
                    svc.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: self.kShowUserTimeLineSegue, sender: self);
                    })
                } else {
                    self.performSegue(withIdentifier: self.kShowUserTimeLineSegue, sender: self);
                }
            }, error: { (error) in
                self.svc?.dismiss(animated: true, completion: nil)
            }) { (requestTokenURL) in
                self.receivedRequestToken(url: requestTokenURL)
        }
    }
    
    func receivedRequestToken(url: URL) {
        self.svc = SFSafariViewController(url: url)
        self.present(self.svc!, animated: true, completion: nil);
    }
    
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue) {
        
    }
}


