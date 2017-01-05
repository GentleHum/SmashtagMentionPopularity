//
//  TwitterSearchMention+CoreDataClass.swift
//  SmashtagMentionPopularity
//
//  Created by Mike Vork on 1/3/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import CoreData


public class TwitterSearchMention: NSManagedObject {
    class func upsertSearchMention(searchText: String, mention: String, context: NSManagedObjectContext) -> TwitterSearchMention? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterSearchMention")
        request.predicate = NSPredicate(format: "searchText == %@ and mention == %@",
                                        searchText, mention)
        
        
        if let searchMention = (try? context.fetch(request))?.first as? TwitterSearchMention {
            // need to increment count by one because we have a new one
            searchMention.count += 1
            return searchMention
        } else if let searchMention = NSEntityDescription.insertNewObject(forEntityName: "TwitterSearchMention", into: context) as? TwitterSearchMention {
            searchMention.searchText = searchText
            searchMention.mention = mention
            searchMention.count = 1
            return searchMention
        }
        
        return nil
    }
}
