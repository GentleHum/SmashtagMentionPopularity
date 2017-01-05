//
//  TwitterUser+CoreDataProperties.swift
//  SmashtagMentionPopularity
//
//  Created by Owner on 1/2/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import CoreData


extension TwitterUser {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterUser> {
        return NSFetchRequest<TwitterUser>(entityName: "TwitterUser");
    }
    
    @NSManaged public var screenName: String?
    @NSManaged public var name: String?
    @NSManaged public var tweets: NSSet?
    
}

// MARK: Generated accessors for tweets
extension TwitterUser {
    
    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: TwitterMessage)
    
    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: TwitterMessage)
    
    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)
    
    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)
    
}
