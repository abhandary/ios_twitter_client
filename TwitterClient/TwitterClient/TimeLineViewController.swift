//
//  TimeLineViewController.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit


class TimeLineViewController: UIViewController  {

    
    static let kNotificationUserLoggedOut = "kNotificationUserLoggedOut"
    let kTweetDetailSegue = "tweetDetailSegue"
    let kTweetComposeSegue = "tweetComposeSegue"

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet]?
    var refreshControl : UIRefreshControl!
    
 
    // for table view infiite scrolling
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(reloadTable), for: UIControlEvents.allEvents)
        
        self.tableView.addSubview(refreshControl)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        reloadTable()
        
    }

    func reloadTable() {
        UserAccount.currentUserAccount?.fetchTweets(success: { (tweets) in
                self.tweets = tweets
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }, error: { (receivedError) in
                
                // @todo: show error banner
                self.refreshControl.endRefreshing()
                print(receivedError)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutButtonPressed(_ sender: AnyObject) {
        User.currentUser = nil
        UserAccount.currentUserAccount = nil
        
        // currently only the AppDelegate listens to this notification, this is required because the current
        // implementation swaps root view controllers. The use of delegates is not straightforward in this implementation
        NotificationCenter.default.post(name: Notification.Name(rawValue: TimeLineViewController.kNotificationUserLoggedOut), object: self)
    }

    // MARK: - Navigation
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if segue.identifier! == TweetComposeViewController.kUnwindToTimeLineViewSegue {
            if let composeVC = segue.source as? TweetComposeViewController,
                let postedTweet = composeVC.postedTweet {
                self.tweets?.insert(postedTweet, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kTweetDetailSegue,
            let cell = sender as? TweetCell,
            let detailVC = segue.destination as? TweetDetailViewController,
            let indexPath = self.tableView.indexPath(for: cell) {
            self.tableView.deselectRow(at: indexPath, animated: true)
            detailVC.tweet = self.tweets![indexPath.row]
            detailVC.tweetCell = cell
        } 
    }
}



extension TimeLineViewController : TweetCellDelegate {
    
    func retweetTapped(sender : TweetCell) {
        
        if  let tweetID = sender.tweet.tweetID {
            UserAccount.currentUserAccount?.post(retweetID: tweetID, success: { (tweet) in
                    sender.tweet.retweetCount = sender.tweet.retweetCount! + 1
                    sender.updateRetweetDisplay()
                    // @todo: insert tweet into timeline
                }, error: { (error) in
                    // @todod: show error banner
                    print(error)
            })
        }
    }
    
    func favoriteTapped(sender: TweetCell) {
        
        if  let tweetID = sender.tweet.tweetID {
            
            if sender.tweet.favorited! == true {
                UserAccount.currentUserAccount?.post(unfavoriteTweetID: tweetID, success: { (tweet) in
                    sender.tweet.favorited = tweet.favorited!
                    sender.tweet.user!.favoritesCount = sender.tweet.user!.favoritesCount! + 1
                    sender.updateFavoritesDisplay()
                    // @todo: insert tweet into timeline
                    }, error: { (error) in
                        // @todod: show error banner
                        print(error)
                })
            } else {
                UserAccount.currentUserAccount?.post(favoriteTweetID: tweetID, success: { (tweet) in
                    
                    sender.tweet.favorited = tweet.favorited!
                    sender.tweet.user!.favoritesCount = max(sender.tweet.user!.favoritesCount! - 1, 0)
                    sender.updateFavoritesDisplay()
                    // @todo: insert tweet into timeline
                    }, error: { (error) in
                        // @todod: show error banner
                        print(error)
                })
            }
        }
    }
}

extension TimeLineViewController : UITableViewDelegate, UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = self.tweets![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
 
        guard self.tweets != nil else { return; }
        guard self.tweets!.count > 0 else { return; }
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                UserAccount.currentUserAccount?.fetchTweetsOlderThanLastFetch(success: { (tweets) in
                    self.isMoreDataLoading = false
                    self.tweets?.append(contentsOf: tweets)
                    self.tableView.reloadData()
                    }, error: { (receivedError) in
                        self.isMoreDataLoading = false
                        // @todo: show error banner
                        print(receivedError)
                })
            }
        }
    }
}
