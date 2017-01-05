//
//  GlobalVariables.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 1/1/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation

struct SearchList {
    static let searchTextsIdentifier = "searchTexts"
    static var searchTexts = [String]()
    
    static func load() {
        let defaults = UserDefaults.standard
        if let retrievedTexts = defaults.array(forKey: searchTextsIdentifier) {
            searchTexts = retrievedTexts as! [String]
        }
    }
    
    static func store() {
        let defaults = UserDefaults.standard
        defaults.set(searchTexts, forKey: searchTextsIdentifier)
    }
    
    static func clear() {
        searchTexts.removeAll()
        store()
    }
    
    static func add(_ newText: String) {
        // remove any duplicates
        searchTexts = searchTexts.filter
            { !($0.localizedCaseInsensitiveCompare(newText) == ComparisonResult.orderedSame) }
        
        while let index = searchTexts.index(of: newText) {
            searchTexts.remove(at: index)
        }
        
        searchTexts.insert(newText, at: 0)  // always put newest search first
        
        store()
    }
}
