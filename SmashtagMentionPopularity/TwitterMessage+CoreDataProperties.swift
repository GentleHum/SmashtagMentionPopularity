//
//  TwitterMessage+CoreDataProperties.swift
//  SmashtagMentionPopularity
//
//  Created by Mike Vork on 1/4/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import CoreData


extension TwitterMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterMessage> {
        return NSFetchRequest<TwitterMessage>(entityName: "TwitterMessage");
    }

    @NSManaged public var posted: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var unique: String?
    @NSManaged public var tweeter: TwitterUser?
    @NSManaged public var searches: NSSet?

}

// MARK: Generated accessors for searches
extension TwitterMessage {

    @objc(addSearchesObject:)
    @NSManaged public func addToSearches(_ value: TwitterSearch)

    @objc(removeSearchesObject:)
    @NSManaged public func removeFromSearches(_ value: TwitterSearch)

    @objc(addSearches:)
    @NSManaged public func addToSearches(_ values: NSSet)

    @objc(removeSearches:)
    @NSManaged public func removeFromSearches(_ values: NSSet)

}
