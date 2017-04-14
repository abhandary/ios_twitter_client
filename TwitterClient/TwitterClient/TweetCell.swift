//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit



class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetedView: UIView!
    
    @IBOutlet weak var retweetedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thumbNailImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    @IBOutlet weak var thumbNailImage: UIImageView!
    
    // replay image
    @IBOutlet weak var replyImageView: UIImageView!
    
    // retweet image + label
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    // favorite image + label
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    
    var tweet : Tweet! {
        didSet {
            
            // self.retweetedViewHeight.isActive = false
            // self.thumbNailImageViewHeight.multiplier = 1.0
            
            tweetTextLabel.text = tweet.text
            
            // user info
            name.text = tweet.user?.name
            handle.text = "@\(tweet.user?.screename)"
            
            // thumbnail
            if let user = tweet.user,
                let imageURL = user.profileURL {
                               self.thumbNailImage.setImageWith(URLRequest(url: imageURL),
                                                 placeholderImage: nil,
                                                 success: { (request, imageResponse, image) in
                                                    if imageResponse != nil {
                                                        
                                                        self.thumbNailImage?.alpha = 0.0
                                                        self.thumbNailImage?.image = image
                                                        self.thumbNailImage?.contentMode = UIViewContentMode.scaleToFill
                                                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                                            self.thumbNailImage?.alpha = 1.0
                                                        })
                                                    } else {
                                                        self.thumbNailImage?.image = image
                                                        self.thumbNailImage?.contentMode = UIViewContentMode.scaleToFill
                                                    }
                                                    self.thumbNailImage.layer.cornerRadius = 5
                                                    self.thumbNailImage.clipsToBounds = true
                    }, failure: { (request, response, error) in
                        print(error)
                })
            }
            
 
            // retweet
            retweetCountLabel.text = String(tweet.retweetCount!)

            // favorite
            favoriteLabel.text = String(tweet.favoritesCount!)
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
