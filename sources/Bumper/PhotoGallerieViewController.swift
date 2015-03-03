//
//  PhotoGallerie.swift
//  Bumper
//
//  Created by Benjamin on 13/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class PhotoGallerieViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var photos : [ALAsset] = []
    var currentIndex : Int!
    var selectButton: UIBarButtonItem!
    var deselectButton: UIBarButtonItem!
    var pageContentViewController = PhotoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton = UIBarButtonItem(title: "Auswählen", style: UIBarButtonItemStyle.Plain, target: self, action: "select:")
        deselectButton = UIBarButtonItem(title: "Abwählen", style: UIBarButtonItemStyle.Plain, target: self, action: "deselect:")
        dataSource = self
        
        self.view.backgroundColor = Color.LIGHTGREY.toUIColor()
        let startingViewController: PhotoViewController = viewControllerAtIndex(currentIndex)!
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        self.title = "" + String(currentIndex+1) + " von " + String(photos.count)


    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as PhotoViewController).pageIndex
        self.title = "" + String(index+1) + " von " + String(photos.count)

        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        currentIndex = index
        index--
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as PhotoViewController).pageIndex
        self.title = "" + String(index+1) + " von " + String(photos.count)

        if index == NSNotFound {
            return nil
        }
        currentIndex = index
        index++
        if (index == photos.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> PhotoViewController?
    {
        if photos.count == 0 || index >= photos.count
        {
            return nil
        }

        // Create a new view controller and pass suitable data.
        pageContentViewController = PhotoViewController()
        pageContentViewController.pageIndex = index
        pageContentViewController.fullSizePhoto = FullSizePhoto(frame: Global.browserContentBounds, asset: photos[index])
        pageContentViewController.view.addSubview(pageContentViewController.fullSizePhoto)

        if (!Global.carousel.contains(pageContentViewController.fullSizePhoto)) {
            self.navigationItem.rightBarButtonItem = selectButton
        } else {
            pageContentViewController.fullSizePhoto.highlight()
            self.navigationItem.rightBarButtonItem = deselectButton
        }
        return pageContentViewController
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    override func select(sender: AnyObject?) {
        var bla = viewControllerAtIndex(currentIndex)
        bla?.fullSizePhoto.highlight()
        var cell = PhotoCell(frame: CGRectMake(0, 0, Global.itemSize.width, Global.itemSize.width), asset: photos[currentIndex])
        cell.imageView.image = UIImage(CGImage: cell.asset.thumbnail().takeUnretainedValue())
        Global.carousel.items.insert(cell, atIndex: 0)
        Global.carousel.insertItemAtIndex(0, animated: true)
    }
    
    func deselect(sender: AnyObject?) {

    }
    

}