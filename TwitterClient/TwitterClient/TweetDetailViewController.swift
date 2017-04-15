//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweet : Tweet?
    
    @IBOutlet weak var thumbNailImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var numberOfRetweetsLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!

    @IBOutlet weak var replyImageView: UIImageView!
    
    @IBOutlet weak var retweetImageView: UIImageView!
    
    @IBOutlet weak var favoritesImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tweet = tweet {
            if let user = tweet.user {
                
                // user thumbnail image
                if let imageURL = user.profileURL {
                    thumbNailImage.setImageWith(imageURL)
                }
                
                // user name and handle
                name.text = user.name
                screenName.text = user.screename
            }
            
            // tweet text
            tweetText.text = tweet.text
            
            // likes count
            if let  likes = tweet.favoritesCount {
                numberOfLikesLabel.text = String(likes)
            }
            
            // retweets count
            if let retweetsCount = tweet.retweetCount {
                numberOfRetweetsLabel.text = String(retweetsCount)
            }
            
            // @todo: set the date
            
            // add gesture recognizers
            let replyImageTapGS = UITapGestureRecognizer(target: self, action: #selector(replyImageTapped))
            replyImageView.addGestureRecognizer(replyImageTapGS)

            let retweetImageTapGS = UITapGestureRecognizer(target: self, action: #selector(retweetImageTapped))
            retweetImageView.addGestureRecognizer(retweetImageTapGS)

            let favoritesImageTapGS = UITapGestureRecognizer(target: self, action: #selector(likeImageTapped))
            favoritesImageView.addGestureRecognizer(favoritesImageTapGS)
        }
        // Do any additional setup after loading the view.
    }

    func replyImageTapped() {
        print("replyImageTapped")
    }

    func retweetImageTapped() {
        print("retweetImageTapped")
    }

    func likeImageTapped() {
        print("likeImageTapped")
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
