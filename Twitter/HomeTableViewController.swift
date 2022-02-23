//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Carlos Chavez on 2/17/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArr = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.tweetArr)

        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweet()
    }
    
    
    @objc func loadTweet() {
        numberOfTweets = 10
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll()
            
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            
            self.myRefreshControl.endRefreshing()
            
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    func loadMoreTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 10
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll()
            
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            
            self.myRefreshControl.endRefreshing()
            
        }, failure: { error in
            print(error.localizedDescription)
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArr.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArr.count {
            loadMoreTweets()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArr[indexPath.row]["user"] as! NSDictionary
        
        
        cell.username.text = user["name"] as? String
        cell.tweetContent.text = tweetArr[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)

        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetArr[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArr[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArr[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
