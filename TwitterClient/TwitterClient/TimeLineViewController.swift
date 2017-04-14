//
//  TimeLineViewController.swift
//  TwitterClient
//
//  Created by Akshay Bhandary on 4/13/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet]?
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(reloadTable), for: UIControlEvents.allEvents)
        
        self.tableView.addSubview(refreshControl)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        reloadTable()
        
    }

    func reloadTable() {
        UserAccountManager.currentUser()?.fetchTweets(success: { (tweets) in
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


extension TimeLineViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.textLabel?.text = self.tweets![indexPath.row].text
        return cell
    }
}
