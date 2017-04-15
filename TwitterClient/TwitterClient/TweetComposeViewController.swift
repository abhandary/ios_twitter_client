//
//  TweetComposeViewController.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

let kUnwindToTimeLineViewSegue = "unwindToTimeLineView"

class TweetComposeViewController: UIViewController {
    
    var user : User?
    
    @IBOutlet weak var tweetEntryTextField: UITextView!
    @IBOutlet weak var thumbNailImageLabel: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!

    
    var tweetCount = 140
    let maxTweetCount = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = User.currentUser {
            if let profileURL = user.profileURL {
                thumbNailImageLabel.setImageWith(profileURL)
                thumbNailImageLabel.clipsToBounds = true
                thumbNailImageLabel.layer.cornerRadius = 5
            }
            nameLabel.text = user.name
            screenNameLabel.text = user.screename
            self.tweetEntryTextField.becomeFirstResponder()
        }
        
        tweetEntryTextField?.delegate = self
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TweetComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let enteredText = tweetEntryTextField.text {
            var enteredTextArray = Array(enteredText.characters)
            tweetCount = enteredTextArray.count
            
            // possible to go over 140 at one go, if the text was pasted, truncate
            if tweetCount > maxTweetCount  {
                tweetCount = 140
                enteredTextArray = Array(enteredTextArray[0..<maxTweetCount])
                tweetEntryTextField.text = String(enteredTextArray)
            }
            countdownLabel.text = String(maxTweetCount - tweetCount)
        }
    }
}
