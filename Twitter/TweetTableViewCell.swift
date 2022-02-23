//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Carlos Chavez on 2/17/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favorited: Bool = false
    var tweetId: Int = -1
    var isRetweeted: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Make profile image a circle
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(TweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { error in
                print(error.localizedDescription)
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(TweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { error in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(TweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { error in
            print(error.localizedDescription)
        })
        
        
    }
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ retweeted:Bool) {
        isRetweeted = retweeted
        if isRetweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
        
    }
}
