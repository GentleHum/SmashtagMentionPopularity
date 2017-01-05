//
//  ImageMentionsTableViewCell.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 1/1/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class ImageMentionsTableViewCell: UITableViewCell {
    
    // MARK: outlets
    
    @IBOutlet private weak var cellImageView: UIImageView!
    
    var imageSource: MediaItem? {
        didSet {
            if self.window != nil {
                fetchImage()
            }
            
            updateUI()
        }
    }
    
    private func updateUI() {
        cellImageView?.image = nil
        /* zap
         // load new information from our image (if any)
         if let imageSource = self.imageSource {
         cellImageView?.image = imageSource.
         }
         */
    }
    
    private func fetchImage() {
        let myImageURL = imageSource?.url
        if let url = myImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak weakSelf = self] in
                let contentsOfURL = NSData(contentsOf: url as URL) as? Data
                DispatchQueue.main.async {
                    if url == myImageURL {
                        if let imageData = contentsOfURL {
                            weakSelf?.cellImageView.image = UIImage(data: imageData)
                            weakSelf?.cellImageView.sizeToFit()
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                    
                }
            }
            
        }
    }
    
    
}
