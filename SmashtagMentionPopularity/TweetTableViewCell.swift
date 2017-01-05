//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Mike Vork on 12/30/16.
//  Copyright © 2016 Mike Vork. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    private struct TweetTextColors {
        static let hashtagColor = UIColor.blue
        static let userColor = UIColor.orange
        static let urlColor = UIColor.red
    }
    
    // MARK: outlets
    @IBOutlet private weak var tweetScreenNameLabel: UILabel!
    @IBOutlet private weak var tweetTextLabel: UILabel!
    @IBOutlet private weak var tweetProfileImageView: UIImageView!
    @IBOutlet private weak var tweetCreatedLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        tweetScreenNameLabel?.text = nil
        tweetTextLabel?.text = nil
        tweetCreatedLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            tweetTextLabel?.attributedText =
                getAttributedString(from: tweet,
                                    inputString: tweetTextLabel.text!)
            
            
            tweetScreenNameLabel?.text = "\(tweet.user)"  // tweet.user.description
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOf: profileImageURL as URL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData as Data)
                }
            }
            
            let formatter = DateFormatter()
            if NSDate().timeIntervalSince(tweet.created as Date) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            
            tweetCreatedLabel?.text = formatter.string(from: tweet.created as Date)
        }
    }
    
    private func getAttributedString(
        from inputTweet: Tweet,
        inputString: String) -> NSAttributedString? {
        
        let myString = NSMutableAttributedString(string: inputString)
        
        for hashtag in inputTweet.hashtags {
            myString.addAttributes(
                [NSForegroundColorAttributeName: TweetTextColors.hashtagColor],
                range: hashtag.nsrange)
        }
        
        for user in inputTweet.userMentions {
            myString.addAttributes(
                [NSForegroundColorAttributeName: TweetTextColors.userColor],
                range: user.nsrange)
        }
        
        for url in inputTweet.urls {
            myString.addAttributes(
                [NSForegroundColorAttributeName: TweetTextColors.urlColor],
                range: url.nsrange)
        }
        
        return myString
    }
    
}
