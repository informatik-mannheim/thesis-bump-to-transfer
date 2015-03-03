//
//  Contact.swift
//  Bumper
//
//  Created by Benjamin on 26/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit

class Contact: NSObject {
    
    var fullName: String!
    var firstName : String!
    var lastName : String!
    var birthday: NSDate?
    var thumbnailImage: NSData?
    var originalImage: NSData?
    
    // these two contain emails and phones in <label> = <value> format
    var emailsArray: Array<Dictionary<String, String>>!
    var phonesArray: Array<Dictionary<String, String>>!
  
    
    init(firstName: String, lastName: String, birthday: NSDate?) {
        self.fullName = firstName + " " + lastName
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
    
    override init() {
        super.init()
    }
    
    required init(coder decoder: NSCoder) {
        self.fullName  = decoder.decodeObjectForKey("fullName") as String?
        self.firstName = decoder.decodeObjectForKey("firstName") as String?
        self.lastName = decoder.decodeObjectForKey("lastName") as String?
        self.birthday  = decoder.decodeObjectForKey("birthday") as NSDate?
        self.thumbnailImage = decoder.decodeObjectForKey("thumbnailImage") as NSData?
        self.originalImage = decoder.decodeObjectForKey("originalImage") as NSData?
        self.emailsArray = decoder.decodeObjectForKey("emailsArray") as Array<Dictionary<String, String>>?
        self.phonesArray = decoder.decodeObjectForKey("phonesArray") as Array<Dictionary<String, String>>?

    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.fullName, forKey: "fullName")
        coder.encodeObject(self.firstName, forKey: "firstName")
        coder.encodeObject(self.lastName, forKey: "lastName")
        coder.encodeObject(self.birthday, forKey: "birthday")
        coder.encodeObject(self.thumbnailImage, forKey: "thumbnailImage")
        coder.encodeObject(self.originalImage, forKey: "originalImage")
        coder.encodeObject(self.emailsArray, forKey: "emailsArray")
        coder.encodeObject(self.phonesArray, forKey: "phonesArray")
    }


    override var description: String { get {
        return "\(firstName) \(lastName) \nBirthday: \(birthday) \nPhones: \(phonesArray) \nEmails: \(emailsArray)\n\n"}
    }
}

func == (contact1: Contact, contact2: Contact) -> Bool {
    return (contact1.fullName == contact2.fullName) && (contact1.birthday == contact1.birthday)
}

func != (contact1: Contact, contact2: Contact) -> Bool {
    return !(contact1 == contact2)
}