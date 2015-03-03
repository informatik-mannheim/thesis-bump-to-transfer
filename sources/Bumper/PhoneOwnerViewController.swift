//
//  PhoneOwnerViewController.swift
//  Bumper
//
//  Created by Benjamin on 27/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation


class PhoneOwnerViewController: UITableViewController {
    
    var contact: Contact!
    var cellArray: [UITableViewCell] = []
    var deSelectButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsetsMake(2.5, -15, 2.5, 0)
        tableView.frame = Global.browserContentBounds
        
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeRightTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeLeftTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeUpTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeDownTwoFingers)
        
        contact = Global.phoneOwner
        
        deSelectButton = UIBarButtonItem(title: "Abwählen", style: UIBarButtonItemStyle.Plain, target: self, action: "deSelect:")
        self.navigationItem.rightBarButtonItem = deSelectButton
        
        var cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"Cell")
        cell.backgroundColor = UIColor.clearColor()
        if (contact.thumbnailImage != nil) {
            cell.imageView?.image = UIImage(data: contact.thumbnailImage!)
            cell.imageView?.layer.cornerRadius = cell.frame.height/2
            cell.imageView?.layer.masksToBounds = true
        }
        cell.textLabel?.text = contact.fullName
        cell.userInteractionEnabled = false
        cellArray.append(cell)
        
        
        for dictionary in contact.phonesArray {
            for (key,value) in dictionary {
                var cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"Cell")
                cell.backgroundColor = UIColor.clearColor()
                cell.textLabel?.text = cleanLabelString(key)
                cell.detailTextLabel?.text = value
                cell.userInteractionEnabled = false
                cellArray.append(cell)
            }
        }
        
        for dictionary in contact.emailsArray {
            for (key,value) in dictionary {
                var cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"Cell")
                cell.backgroundColor = UIColor.clearColor()
                cell.textLabel?.text = cleanLabelString(key)
                cell.detailTextLabel?.text = value
                cell.userInteractionEnabled = false
                cellArray.append(cell)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = cellArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
        return cell
    }
    
    func cleanLabelString(string: String) -> String {
        return string.substringWithRange(Range<String.Index>(start: advance(string.startIndex, 4), end: advance(string.endIndex, -4)))
        
    }
    
    func deSelect(sender: AnyObject?) {
        Global.phoneOwner = nil
        Global.profilePicture.image = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey("phoneOwner")
    }
}