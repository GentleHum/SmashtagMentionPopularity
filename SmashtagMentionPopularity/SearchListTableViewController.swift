//
//  SearchListTableViewController.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 12/31/16.
//  Copyright © 2016 Mike Vork. All rights reserved.
//

import UIKit

class SearchListTableViewController: UITableViewController {
    private struct Storyboard {
        static let searchesCellIdentifier = "searches"
        static let searchTextSequeIdentifier = "SearchTextSegue"
        static let showMentionsPopularitySegue = "ShowMentionsPopularitySegue"
        static let maxRowsToShow = 100
    }
    
   
    @IBAction private func clearSearchList(_ sender: UIBarButtonItem) {
        
        let clearAlert = UIAlertController(title: "Clear", message: "All search terms will be lost.\nAre you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        clearAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            SearchList.clear()
            self.searchTexts = SearchList.searchTexts
        }))
        
        clearAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(clearAlert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove empty rows at bottom of table
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTexts = SearchList.searchTexts
    }
    
    var searchTexts = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return min(searchTexts.count, Storyboard.maxRowsToShow)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.searchesCellIdentifier, for: indexPath)
        
        let searchText = searchTexts[indexPath.row]
        if let searchCell = cell as? SearchListTableViewCell {
            searchCell.searchText = searchText
        }
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.searchTextSequeIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destination = segue.destination.contentViewController as? TweetTableViewController {
                    destination.searchText = searchTexts[indexPath.row]
                }
            }
        } else if segue.identifier == Storyboard.showMentionsPopularitySegue {
            if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
                if let destination = segue.destination.contentViewController as? MentionsPopularityTableViewController {
                    destination.searchText = searchTexts[indexPath.row]
                    destination.persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
                }
            }
        }
    }
    
    
}
