//
//  TwitterSearch+CoreDataProperties.swift
//  SmashtagMentionPopularity
//
//  Created by Mike Vork on 1/4/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import CoreData


extension TwitterSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterSearch> {
        return NSFetchRequest<TwitterSearch>(entityName: "TwitterSearch");
    }

    @NSManaged public var text: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension TwitterSearch {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: TwitterMessage)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: TwitterMessage)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}
