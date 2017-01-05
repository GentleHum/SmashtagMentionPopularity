//
//  ViewController+Extensions.swift
//  GraphicCalculator
//
//  Created by Mike Vork on 12/28/16.
//  Copyright © 2016 Owner. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // helps deal with the difference between iPhone and iPad in UISplitViewController
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
    
}
