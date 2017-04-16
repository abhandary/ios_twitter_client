//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    let kFavoritedImage = "favorite_heart"
    let kUnfavoritedImage = "unfavorite_heart"
    
    let kRetweetedImage = "retweeted"
    let kNotRetweetedImage = "notretweeted"
    
    let kTweetReplyFromDetailSegue = "tweetReplyFromDetailSegue"

    
    var tweet : Tweet?
    
    var tweetCell : TweetCell?
    
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

            // likes
            if let  likes = tweet.favoritesCount {
                numberOfLikesLabel.text = String(likes)
            }
            updateFavoritesImage()

            
            
            // retweets count
            if let retweetsCount = tweet.retweetCount {
                numberOfRetweetsLabel.text = String(retweetsCount)
            }
            updateRetweetImage()
            
            // tweet text
            tweetText.text = tweet.text
            
            
            // @todo: set the date
            
            // add gesture recognizers
            let replyImageTapGS = UITapGestureRecognizer(target: self, action: #selector(replyImageTapped))
            replyImageView.isUserInteractionEnabled = true
            replyImageView.addGestureRecognizer(replyImageTapGS)

            let retweetImageTapGS = UITapGestureRecognizer(target: self, action: #selector(retweetImageTapped))
            retweetImageView.isUserInteractionEnabled = true
            retweetImageView.addGestureRecognizer(retweetImageTapGS)

            let favoritesImageTapGS = UITapGestureRecognizer(target: self, action: #selector(likeImageTapped))
            favoritesImageView.isUserInteractionEnabled = true
            favoritesImageView.addGestureRecognizer(favoritesImageTapGS)
        }
        // Do any additional setup after loading the view.
    }

    func replyImageTapped() {
        self.performSegue(withIdentifier: kTweetReplyFromDetailSegue, sender: self)
    }

    func retweetImageTapped() {

        if let tweet = tweet,
            let tweetID = tweet.tweetID {
            
            let successBlock : (Tweet) -> () = { (receivedTweet)  in
                tweet.updateWith(tweet: receivedTweet)
                self.updateRetweetCountDisplay()
                self.updateRetweetImage()
            }
            
            let errorBlock : (Error)->() = { (error) in
                // @todo: show error banner
            }
            
            if tweet.retweeted == false {
                UserAccount.currentUserAccount?.post(retweetID: tweetID, success: successBlock, error: errorBlock)
            } else {
                if let originalTweetIDStr = tweet.originalTweetID,
                    let originalID = Int(originalTweetIDStr) {
                    UserAccount.currentUserAccount?.post(unretweetID: originalID, success: successBlock, error: errorBlock)
                } else {
                    errorBlock(NSError(domain: "No original ID in retweet", code: 0, userInfo: nil))
                }
            }

        }
    }

    func likeImageTapped() {
        if let tweet = tweet,
            let tweetID = tweet.tweetID {
            
            let successBlock : (Tweet) -> () = { (receivedTweet)  in
                tweet.updateWith(tweet: receivedTweet)
                self.updateFavoriteCountDisplay()
                self.updateFavoritesImage()
            }
            
            let errorBlock : (Error)->() = { (error) in
                // @todo: show error banner
            }

            
            if tweet.favorited! == false {
                UserAccount.currentUserAccount?.post(favoriteTweetID: tweetID, success: successBlock, error: errorBlock)
            } else {
                UserAccount.currentUserAccount?.post(unfavoriteTweetID: tweetID, success: successBlock, error: errorBlock)
            }
        }
    }

    
    func updateRetweetCountDisplay() {
        
        if let tweet = tweet {
            numberOfRetweetsLabel.text = String(tweet.retweetCount!)
            if let tweetCell = tweetCell {
                tweetCell.updateRetweetDisplay()
            }
        }
    }

    func updateRetweetImage() {
        
        if let tweet = tweet {
            // update favorite image as per favorite state
            var newImage : UIImage!
            if let retweeted = tweet.retweeted,
                retweeted == true {
                newImage = UIImage(named: kRetweetedImage)
            } else {
                newImage = UIImage(named: kNotRetweetedImage)
            }
            
            UIView.transition(with: retweetImageView,
                              duration: 0.1,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                self.retweetImageView.image = newImage
                }, completion: nil)
            
            
            self.retweetImageView.setNeedsDisplay()
        }
    }
    
    func updateFavoritesImage() {
        
        if let tweet = tweet {
            // likes count
            // update favorite image as per favorite state
            var newImage : UIImage!
            if let favorited = tweet.favorited,
                favorited == true {
                newImage = UIImage(named: kFavoritedImage)
                // favoriteImage.image = UIImage(named: kFavoritedImage)
            } else {
                newImage = UIImage(named: kUnfavoritedImage)
                // favoriteImage.image = UIImage(named: kUnfavoritedImage)
            }
            
            UIView.transition(with: favoritesImageView,
                              duration: 0.1,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                self.favoritesImageView.image = newImage
                }, completion: nil)
            
            
            self.favoritesImageView.setNeedsDisplay()
        }
    }

  
    func updateFavoriteCountDisplay() {
        
        if let tweet = tweet {
            tweet.favoritesCount = tweet.favoritesCount!
            numberOfLikesLabel.text = String(tweet.favoritesCount!)
            if let tweetCell = tweetCell {
                tweetCell.updateFavoritesDisplay()
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier! == kTweetReplyFromDetailSegue,
            let navVC = segue.destination as? UINavigationController,
            let composeVC = navVC.topViewController as? TweetComposeViewController,
            let tweet = tweet,
            let tweetID = tweet.tweetID {

            // set in reply to ID and screename
            composeVC.inReplyToID = tweetID
            composeVC.inReplyToScreenName = tweet.user?.screename
        }
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
