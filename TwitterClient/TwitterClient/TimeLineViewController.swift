//
//  TimeLineViewController.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

let kNotificationUserLoggedOut = "kNotificationUserLoggedOut"
let kTweetDetailSegue = "tweetDetailSegue"
let kTweetComposeSegue = "tweetComposeSegue"

class TimeLineViewController: UIViewController {

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
        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUserLoggedOut), object: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kTweetDetailSegue,
            let cell = sender as? UITableViewCell,
            let detailVC = segue.destination as? TweetDetailViewController,
            let indexPath = self.tableView.indexPath(for: cell) {
            detailVC.tweet = self.tweets![indexPath.row]
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
