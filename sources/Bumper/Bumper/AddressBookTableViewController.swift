//
//  AddressBookTableViewController.swift
//  Bumper
//
//  Created by Benjamin on 25/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import AddressBook

class AddressBookTableViewController: UITableViewController {
    
    var contactList = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.title = "Kontakte"
        tableView.contentInset = UIEdgeInsetsMake(2.5, -15, 2.5, 0)
        tableView.frame = Global.browserContentBounds
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeRightTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeLeftTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeUpTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeDownTwoFingers)
        //getContactList()
        ContactsImporter.importContacts(saveToArray)
    }

    func saveToArray(contacts: Array<Contact>) {
        contactList = contacts
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"Cell")
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = contactList[indexPath.row].fullName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var contactViewController = ContactViewController()
        contactViewController.contact = contactList[indexPath.row]
        navigationController?.pushViewController(contactViewController, animated: true)
    }
}
