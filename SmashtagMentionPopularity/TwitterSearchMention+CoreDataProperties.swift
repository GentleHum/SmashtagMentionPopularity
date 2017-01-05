//
//  TwitterSearchMention+CoreDataProperties.swift
//  SmashtagMentionPopularity
//
//  Created by Mike Vork on 1/3/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import CoreData


extension TwitterSearchMention {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterSearchMention> {
        return NSFetchRequest<TwitterSearchMention>(entityName: "TwitterSearchMention");
    }

    @NSManaged public var searchText: String?
    @NSManaged public var mention: String?
    @NSManaged public var count: Int32

}
