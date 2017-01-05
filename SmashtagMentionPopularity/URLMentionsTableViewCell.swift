//
//  URLMentionsTableViewCell.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 1/1/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class URLMentionsTableViewCell: UITableViewCell {
    
    
    // MARK: outlets
    @IBOutlet private weak var urlTextLabel: UILabel!
    
    var url: Tweet.IndexedKeyword? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        urlTextLabel?.text = nil
        
        // load new information from our url (if any)
        if let url = self.url {
            urlTextLabel?.text = url.keyword
        }
    }
    
}
