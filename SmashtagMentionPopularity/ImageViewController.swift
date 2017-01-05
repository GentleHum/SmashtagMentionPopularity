//
//  ImageViewController.swift
//  SmashtagMentions
//
//  Created by Mike Vork on 1/1/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    var imageAspectRatio: Double?
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func fetchImage() {
        let myImageURL = imageURL as? URL
        if let url = myImageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = NSData(contentsOf: url) as? Data
                DispatchQueue.main.async {
                    if url == myImageURL {
                        if let imageData = contentsOfURL {
                            self.image = UIImage(data: imageData)
                        } else {
                            self.spinner?.stopAnimating()
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                    
                }
            }
            
        }
    }
    
    private var imageView = UIImageView()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            scrollView?.zoom(to: self.imageView.bounds, animated: false)
            spinner?.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.addSubview(imageView)
        spinner.hidesWhenStopped = true
    }
    
}
