//
//  TwitterUser+CoreDataClass.swift
//  SmashtagMentionPopularity
//
//  Created by Owner on 1/2/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import CoreData


public class TwitterUser: NSManagedObject {
    
    class func twitterUserWithTwitterInfo(twitterInfo: User, context: NSManagedObjectContext) -> TwitterUser? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.screenName)
        
        
        if let twitterUser = (try? context.fetch(request))?.first as? TwitterUser {
            return twitterUser
        } else if let twitterUser = NSEntityDescription.insertNewObject(forEntityName: "TwitterUser", into: context) as? TwitterUser {
            twitterUser.screenName = twitterInfo.screenName
            twitterUser.name = twitterInfo.name
            return twitterUser
        }
        
        return nil
    }
    
    
    
}
