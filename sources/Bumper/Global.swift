//
//  Global.swift
//  Bumper
//
//  Created by Benjamin on 05/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import AssetsLibrary
import AddressBook

struct Global {
   
    static let assetsLibrary = ALAssetsLibrary()
    static var assetsArray : [ALAssetsGroup] = []
    static var carousel: Carousel!
    static var phoneOwner: Contact!
    static var profilePicture: ProfilePicture!
    
    static var swipeLeft: UISwipeGestureRecognizer!
    static var swipeRight: UISwipeGestureRecognizer!
    static var swipeUp: UISwipeGestureRecognizer!
    static var swipeDown: UISwipeGestureRecognizer!
    static var swipeRightTwoFingers: UISwipeGestureRecognizer!
    static var swipeLeftTwoFingers: UISwipeGestureRecognizer!
    static var swipeUpTwoFingers: UISwipeGestureRecognizer!
    static var swipeDownTwoFingers: UISwipeGestureRecognizer!
    
    //Layout Frames
    static let screen = UIScreen.mainScreen().bounds
    static let statusBar = UIApplication.sharedApplication().statusBarFrame
    static let center = CGPointMake(screen.midX, screen.midY)
    static let footer = CGRectMake(screen.minX, screen.maxY-(screen.height-statusBar.height)/10, screen.width, (screen.height-statusBar.height)/10)
    static let header = CGRectMake(screen.minX, screen.minY, footer.width, footer.height + statusBar.height)
    static let body = CGRectMake(screen.minX, header.maxY, screen.width, (screen.height-statusBar.height)-(footer.height*2))
    static let screenPadding: CGFloat = 27.5
    
    //Browser
    static let headerHeight: CGFloat = 21
    static let padding: CGFloat = 2.5
    
    static let browserFrame = CGRectMake(screen.minX + screenPadding, header.maxY + screenPadding, body.width - (screenPadding*2), body.height - (screenPadding*2) + padding)
    static let browserBounds = CGRectMake(0, 0, body.width - (screenPadding*2), body.height - (screenPadding*2) + padding)
    
    static let browserHeaderFrame = CGRectMake(padding, padding, browserFrame.width-(padding*2), headerHeight)
    static let browserFooterFrame = CGRectMake(padding, browserContentFrame.maxY + padding, browserFrame.width-(padding*2), headerHeight)
   
    static let browserNavBarFrame = CGRectMake(0, 0, browserFrame.width-(padding*2), headerHeight)
    static let browserContentFrame = CGRectMake(padding, browserTopCarouselFrame.maxY, browserFrame.width-(padding*2), browserFrame.width-(padding*2) + browserNavBarFrame.height)

    static let browserContentBounds = CGRectMake(0, browserNavBarFrame.maxY + padding, browserFrame.width-(padding*2), browserFrame.width-(padding*2))
    
    static let browserTopCarouselFrame = CGRectMake(padding, browserHeaderFrame.maxY, browserFrame.width-(padding*2), (browserFrame.width-(padding*2))/4)
    
    static let itemSize = CGSize(width: (Global.browserContentFrame.width - (Global.padding*3))/4, height: (Global.browserContentFrame.width - (Global.padding*3))/4)
    
    //static let bottomCarouselFrame = CGRectMake(browser.minX+5, browser.midY, browser.width-10, browser.height/2)
    static let fontSize: CGFloat = 30
}