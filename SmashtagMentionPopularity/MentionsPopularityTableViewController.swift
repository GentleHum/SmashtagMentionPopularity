//
//  MentionsPopularityTableViewController.swift
//  SmashtagMentionPopularity
//
//  Created by Mike Vork on 1/2/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import UIKit
import CoreData

class MentionsPopularityTableViewController: CoreDataTableViewController {
    
    private struct Storyboard {
        static let mentionsPopularityCell = "MentionsPopularityCell"
    }
    
    var searchText: String? {
        didSet {
            updateUI()
        }
    }
    
    var persistentContainer: NSPersistentContainer? {
        didSet {
            managedObjectContext = persistentContainer?.viewContext
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = (searchText != nil) ? "\(searchText!) Mentions" : "Mentions"
    }
    
    private var managedObjectContext: NSManagedObjectContext?
    
    private func updateUI() {
        if let context = managedObjectContext, (searchText?.characters.count)! > 0 {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterSearchMention")
            request.predicate = NSPredicate(format: "any searchText == %@ and count > 1", searchText!)
            request.sortDescriptors = [
                NSSortDescriptor(key: "count", ascending: false),
                NSSortDescriptor(key: "mention", ascending: true,
                                 selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))),
            ]
           

            self.fetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mentionsPopularityCell, for: indexPath)
        
        if let searchMention = fetchedResultsController?.object(at: indexPath) as? TwitterSearchMention {
            var mention: String?
            searchMention.managedObjectContext?.performAndWait {
                mention = searchMention.mention
            }
            cell.textLabel?.text = mention
            cell.detailTextLabel?.text = "\(searchMention.count) mentions"
        }
        
        
        return cell
    }
    
    
    
}
