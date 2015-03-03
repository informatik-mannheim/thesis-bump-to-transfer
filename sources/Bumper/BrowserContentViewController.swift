//
//  BrowserContentViewController.swift
//  Bumper
//
//  Created by Benjamin on 17/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit


class BrowserContentViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = Global.browserContentFrame
        navigationBar.barTintColor = Color.DARKGREY.toUIColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: Color.LIGHTGREY.toUIColor()]
        navigationBar.titleTextAttributes = titleDict
        navigationBar.tintColor = Color.BLUE.toUIColor()
        let albumTable = AlbumTableViewController()
        addChildViewController(albumTable)
    }
}