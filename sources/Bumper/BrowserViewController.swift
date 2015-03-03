//
//  BrowserViewController.swift
//  Bumper
//
//  Created by Benjamin on 17/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit

class BrowserViewController: UIViewController {

    var header: UIView!
    var footer: UIView!
    var lastLocation:CGPoint = CGPointMake(0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = Global.browserFrame
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(1, 1)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 1.0
    }
}