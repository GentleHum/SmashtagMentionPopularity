//
//  UserMentionsTableViewCell.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 1/1/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class UserMentionsTableViewCell: UITableViewCell {
    
    // MARK: outlets
    @IBOutlet private weak var userTextLabel: UILabel!
    
    var user: Tweet.IndexedKeyword? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        userTextLabel?.text = nil
        
        // load new information from our user (if any)
        if let user = self.user {
            userTextLabel?.text = user.keyword
        }
    }
    
}
