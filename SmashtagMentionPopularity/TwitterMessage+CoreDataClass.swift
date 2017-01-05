//
//  TwitterMessage+CoreDataClass.swift
//  SmashtagMentionPopularity
//
//  Created by Owner on 1/2/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import CoreData


public class TwitterMessage: NSManagedObject {
    
    private func addToSearches(searchText: String) {
        if searches == nil {
            searches = NSSet()
        }
        
        if let twitterSearch = TwitterSearch.twitterSearchWithSearchText(searchText: searchText,
                                                                         context: self.managedObjectContext!) {
            let mutableSet = mutableSetValue(forKey: "searches")
            mutableSet.add(twitterSearch)
        }
  
    }
    
    // before calling this method, caller must ensure the search text should be inserted
    private func processSearchMentions(with twitterInfo: Tweet, searchText: String?, context: NSManagedObjectContext) {
        if searchText != nil {
            
            // add to the search list
            addToSearches(searchText: searchText!)  // add to list of searches for this tweet
            
            // and update the mentions for this search text
            updateMentions(for: searchText!,
                           mentions: twitterInfo.userMentions,
                           context: context)
            updateMentions(for: searchText!,
                           mentions: twitterInfo.hashtags,
                           context: context)
        }
    }
    
    
    // update the TwitterSearchMention object type with new mentions for the given search text
    private func updateMentions(for searchText: String,
                                mentions: [Tweet.IndexedKeyword],
                                context: NSManagedObjectContext) {
        for mention in mentions {
            if searchText.uppercased() != mention.keyword.uppercased() {
                _ = TwitterSearchMention.upsertSearchMention(searchText: searchText,
                                                             mention: mention.keyword,
                                                             context: context)
            }
        }
    }
    
    private func searchAlreadyExists(searchText: String?) -> Bool {
        if searchText == nil {  // nothing for which to search, treat as already exists
            return true
        } else if let twitterSearch = TwitterSearch.findExistingSearch(searchText: searchText!,
                                                                       context: self.managedObjectContext!) {
            if let returnValue = searches?.contains(twitterSearch) {
                return returnValue
            }
        }

        return false
    }
    
    
    class func tweetWithTwitterInfo(twitterInfo: Tweet, searchText: String?, context: NSManagedObjectContext) -> TwitterMessage? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterMessage")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id!)
        
        
        if let twitterMessage = (try? context.fetch(request))?.first as? TwitterMessage {
            if !twitterMessage.searchAlreadyExists(searchText: searchText) {
                twitterMessage.processSearchMentions(with: twitterInfo, searchText: searchText, context: context)
            }
            return twitterMessage
        } else if let twitterMessage = NSEntityDescription.insertNewObject(forEntityName: "TwitterMessage", into: context) as? TwitterMessage {
            twitterMessage.unique = twitterInfo.id
            twitterMessage.text = twitterInfo.text
            twitterMessage.posted = twitterInfo.created
            twitterMessage.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo: twitterInfo.user, context: context)
            
            twitterMessage.processSearchMentions(with: twitterInfo,
                                                 searchText: searchText,
                                                 context: context)
            
            return twitterMessage
        }
        
        return nil
    }
    
}
