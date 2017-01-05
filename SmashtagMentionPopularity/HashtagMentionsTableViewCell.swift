//
//  HashtagMentionsTableViewCell.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 12/31/16.
//  Copyright © 2016 Mike Vork. All rights reserved.
//

import UIKit

class HashtagMentionsTableViewCell: UITableViewCell {
    
    // MARK: outlets
    @IBOutlet private weak var hashtagTextLabel: UILabel!
    
    var hashtag: Tweet.IndexedKeyword? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        hashtagTextLabel?.text = nil
        
        // load new information from our hashtag (if any)
        if let hashtag = self.hashtag {
            hashtagTextLabel?.text = hashtag.keyword
        }
    }
    
}
