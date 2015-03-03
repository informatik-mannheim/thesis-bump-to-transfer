//
//  ContactViewController.swift
//  Bumper
//
//  Created by Benjamin on 26/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import AddressBook

class ContactViewController: UITableViewController {
    
    var contact: Contact!
    var cellArray: [UITableViewCell] = []
    var selectButton: UIBarButtonItem!
    var deSelectButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!

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
        
        selectButton = UIBarButtonItem(title: "Auswählen", style: UIBarButtonItemStyle.Plain, target: self, action: "select:")
        deSelectButton = UIBarButtonItem(title: "Abwählen", style: UIBarButtonItemStyle.Plain, target: self, action: "deSelect:")
        saveButton = UIBarButtonItem(title: "Speichern", style: UIBarButtonItemStyle.Plain, target: self, action: "save:")
        self.navigationItem.rightBarButtonItem = saveButton
//        if (Global.phoneOwner != nil) {
//            if (Global.phoneOwner == contact) {
//                self.navigationItem.rightBarButtonItem = deSelectButton
//            } else {
//                self.navigationItem.rightBarButtonItem = selectButton
//            }
//        } else {
//            self.navigationItem.rightBarButtonItem = selectButton
//        }
        
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
        
        if (contact.phonesArray != nil) {
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
        }
        
        if (contact.emailsArray != nil) {
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
    
    override func select(sender: AnyObject?) {
        Global.phoneOwner = contact
        Global.profilePicture.image = UIImage(data: contact.thumbnailImage!)
        let data = NSKeyedArchiver.archivedDataWithRootObject(contact)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "phoneOwner")
        self.navigationItem.rightBarButtonItem = deSelectButton
    }
    
    func deSelect(sender: AnyObject?) {
        Global.phoneOwner = nil
        Global.profilePicture.image = nil
        self.navigationItem.rightBarButtonItem = selectButton
        NSUserDefaults.standardUserDefaults().removeObjectForKey("phoneOwner")
    }
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func save(sender: AnyObject?) {
        var errorRef: Unmanaged<CFError>? = nil
        var addressBook: ABAddressBookRef? = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        
        var newContact:ABRecordRef! = ABPersonCreate().takeRetainedValue()
        var success:Bool = false
        var newFirstName:NSString = contact.firstName
        var newLastName = contact.lastName
        
        //Updated to work in Xcode 6.1
        var error: Unmanaged<CFErrorRef>? = nil
        //Updated to error to &error so the code builds in Xcode 6.1
        success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, newFirstName, &error)
        println("setting first name was successful? \(success)")
        success = ABRecordSetValue(newContact, kABPersonLastNameProperty, newLastName, &error)
        println("setting last name was successful? \(success)")
        success = ABAddressBookAddRecord(addressBook, newContact, &error)
        println("Adbk addRecord successful? \(success)")
        success = ABAddressBookSave(addressBook, &error)
        println("Adbk Save successful? \(success)")

    }

}