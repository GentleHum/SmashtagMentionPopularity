//
//  MentionsTableViewController.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 12/31/16.
//  Copyright © 2016 Mike Vork. All rights reserved.
//

import UIKit
import SafariServices


class MentionsTableViewController: UITableViewController {
    
    private enum SectionType: Int {
        case imageMentions = 0
        case hashtagMentions = 1
        case userMentions = 2
        case urlMentions = 3
    }
    
    // storyboard constants
    private struct Storyboard {
        // cell identifiers
        static let hashtagMentionsCellIdentifier = "HashtagMentions"
        static let imageMentionsCellIdentifier = "ImageMentions"
        static let userMentionsCellIdentifier = "UserMentions"
        static let urlMentionsCellIdentifier = "URLMentions"
        
        // segues
        static let hashtagSegue = "HashtagSegue"
        static let imageSegue = "ImageSegue"
        static let userSegue = "UserSegue"
        static let urlSegue = "URLSegue"
    }
    
    
    private struct MentionSection {
        var name: String
        var type: SectionType
        var count: Int
    }
    
    private var sections = [MentionSection]()
    
    var tweet: Tweet? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove empty rows at bottom of table
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load the section data here
        sections.removeAll()
        if let tweet = self.tweet {
            if tweet.media.count > 0 {
                sections.append(MentionSection(name: "Images", type: .imageMentions, count: tweet.media.count))
            }
            if tweet.hashtags.count > 0 {
                sections.append(MentionSection(name: "Hashtags", type: .hashtagMentions, count: tweet.hashtags.count))
            }
            if tweet.userMentions.count > 0 {
                sections.append(MentionSection(name: "Users", type: .userMentions, count: tweet.userMentions.count))
            }
            if tweet.urls.count > 0 {
                sections.append(MentionSection(name: "URLs", type: .urlMentions, count: tweet.urls.count))
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch sections[indexPath.section].type {
        case .imageMentions:
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.imageMentionsCellIdentifier, for: indexPath)
            if let mentionsCell = cell as? ImageMentionsTableViewCell {
                mentionsCell.imageSource = tweet?.media[indexPath.row]
            }
            
        case .hashtagMentions:
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.hashtagMentionsCellIdentifier, for: indexPath)
            if let mentionsCell = cell as? HashtagMentionsTableViewCell {
                mentionsCell.hashtag = tweet?.hashtags[indexPath.row]
            }
            
        case .userMentions:
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.userMentionsCellIdentifier, for: indexPath)
            if let mentionsCell = cell as? UserMentionsTableViewCell {
                mentionsCell.user = tweet?.userMentions[indexPath.row]
            }
            
        case .urlMentions:
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.urlMentionsCellIdentifier, for: indexPath)
            if let mentionsCell = cell as? URLMentionsTableViewCell {
                mentionsCell.url = tweet?.urls[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].type == SectionType.imageMentions {
            let width = tableView.frame.width
            if let aspectRatio = tweet?.media[indexPath.row].aspectRatio, aspectRatio > 0.0 {
                return width / CGFloat(aspectRatio)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.hashtagSegue:
                let sendingCell = sender as? HashtagMentionsTableViewCell
                if let destination = segue.destination.contentViewController as? TweetTableViewController {
                    destination.searchText = sendingCell?.hashtag?.keyword
                }
            case Storyboard.userSegue:
                let sendingCell = sender as? UserMentionsTableViewCell
                if let destination = segue.destination.contentViewController as? TweetTableViewController {
                    destination.searchText = sendingCell?.user?.keyword
                }
            case Storyboard.imageSegue:
                let sendingCell = sender as? ImageMentionsTableViewCell
                if let destination = segue.destination.contentViewController as? ImageViewController {
                    destination.imageURL = sendingCell?.imageSource?.url
                    destination.imageAspectRatio = sendingCell?.imageSource?.aspectRatio
                }
            default:
                break
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? URLMentionsTableViewCell {
            if cell.reuseIdentifier == Storyboard.urlMentionsCellIdentifier {
                let safariVC = SFSafariViewController(url: URL(string: cell.url!.keyword)!)
                safariVC.delegate = self
                present(safariVC, animated: true, completion: nil)
            }
        }
        
        
    }
}

extension MentionsTableViewController: SFSafariViewControllerDelegate {
    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
