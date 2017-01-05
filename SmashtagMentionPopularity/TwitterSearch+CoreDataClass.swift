//
//  TwitterSearch+CoreDataClass.swift
//  SmashtagMentionPopularity
//
//  Created by Mike Vork on 1/4/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import CoreData


public class TwitterSearch: NSManagedObject {
    class func twitterSearchWithSearchText(searchText: String, context: NSManagedObjectContext) -> TwitterSearch? {
        
        if let twitterSearch = findExistingSearch(searchText: searchText, context: context) {
            return twitterSearch
        } else if let twitterSearch = NSEntityDescription.insertNewObject(forEntityName: "TwitterSearch", into: context) as? TwitterSearch {
            twitterSearch.text = searchText
            twitterSearch.created = NSDate()
            return twitterSearch
        }
        
        return nil
    }

    class func findExistingSearch(searchText: String, context: NSManagedObjectContext) -> TwitterSearch? {
        // case insensitive search
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterSearch")
        request.predicate = NSPredicate(format: "text == %@", searchText)
        
        return (try? context.fetch(request))?.first as? TwitterSearch
    }

}
