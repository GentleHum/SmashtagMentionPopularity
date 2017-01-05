//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Mike Vork on 12/30/16.
//  Copyright © 2016 Mike Vork. All rights reserved.
//

import UIKit
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    private struct Storyboard {
        static let tweetCellIdentifier = "tweet"
        static let mentionsSequeIdentifier = "Show Mentions"
        static let tweetersMentionSearchIdentifier = "TweetersMentioningSearchTermSegue"
    }
    
    private var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
//    internal var refreshControl = UIRefreshControl()

    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private var managedObjectContext: NSManagedObjectContext?
    
    var persistentContainer: NSPersistentContainer? {
        didSet {
            managedObjectContext = persistentContainer?.viewContext
        }
    }
    
    
    var searchText: String? = SearchList.searchTexts.first {
        didSet {
            tweets.removeAll()
            searchForTweets()
            self.navigationItem.title = searchText
            if searchText != nil {
                SearchList.add(searchText!)
            }
        }
    }
    
    private var twitterRequest: TwitterRequest? {
        if let query = searchText, !query.isEmpty {
            return TwitterRequest(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: TwitterRequest?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            spinner?.startAnimating()
            lastTwitterRequest = request
            request.fetchTweets() { [weak weakSelf = self] newTweets in
                DispatchQueue.main.async() {
                    // zap, fix                   let lastRequest = weakSelf?.lastTwitterRequest
                    //                    if let lastRequest = weakSelf?.lastTwitterRequest, request == lastRequest {
                    if !newTweets.isEmpty {
                        weakSelf?.tweets.insert(newTweets, at: 0)
                        weakSelf?.updateDatabase(newTweets: newTweets)
                    } else {
                        weakSelf?.spinner?.stopAnimating()
                    }
                    //                    }
                }
            }
        }
    }
    
    private func updateDatabase(newTweets: [Tweet]) {
        managedObjectContext?.perform { [weak weakSelf = self] in
            
            // add new tweets, including search mentions
            for twitterInfo in newTweets {
                // create a new, unique TwitterMessage (not Tweet) with this Twitter info
                _ = TwitterMessage.tweetWithTwitterInfo(twitterInfo: twitterInfo, searchText: weakSelf?.searchText, context: self.managedObjectContext!)
            }
            
            
            // now save new data to the database
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
            
        }
        
        printDatabaseStatistics()
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform {
            if let results = try? self.managedObjectContext!.fetch(NSFetchRequest(entityName: "TwitterUser")) {
                print("\(results.count) TwitterUsers")
            }
            
            // a more efficient way to count objects...
            let tweetCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "TwitterMessage"))
            print("\(tweetCount!) Tweets")
            
            let searchMentionCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "TwitterSearchMention"))
            print("\(searchMentionCount!) SearchMention combos")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // remove empty rows at bottom of table
        tableView.tableFooterView = UIView()
        
        if persistentContainer == nil {
            persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        }
        
        spinner?.hidesWhenStopped = true
        
        // setup the "pull to refresh" option
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(TweetTableViewController.handleTableRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    
    @objc func handleTableRefresh(_ refreshControl: UIRefreshControl) {
        searchForTweets()
        refreshControl.endRefreshing()
    }
    
    private func showErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Service Error", message: errorMessage, preferredStyle: .alert)
        
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // ...
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tweetCellIdentifier, for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            self.searchTextField.delegate = self
            self.searchTextField.text = searchText
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchText = textField.text
        return true
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Storyboard.mentionsSequeIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destination = segue.destination as? MentionsTableViewController {
                    destination.tweet = tweets[indexPath.section][indexPath.row]
                }
            }
        } else if segue.identifier == Storyboard.tweetersMentionSearchIdentifier {
            if let tweetersTVC = segue.destination.contentViewController as? TweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.persistentContainer = persistentContainer
            }
        }
    }
    
    
}
