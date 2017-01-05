//
//  SearchListTableViewCell.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 12/31/16.
//  Copyright © 2016 Mike Vork. All rights reserved.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {
    
    // MARK: outlets
    @IBOutlet private weak var searchTextLabel: UILabel!
    
    var searchText: String? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        searchTextLabel?.text = nil
        
        // load new information from our search text (if any)
        if let searchText = self.searchText {
            searchTextLabel?.text = searchText
        }
    }
    
    
    
}
