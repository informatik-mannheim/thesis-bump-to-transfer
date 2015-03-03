//
//  PhotoCollectionViewController.swift
//  Bumper
//
//  Created by Benjamin on 17/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import AssetsLibrary

class PhotoCollectionViewController: UICollectionViewController {
    
    var album: ALAssetsGroup!
    var photos : [ALAsset] = []
    var multiSelect = false
    var multiButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerClass(PhotoCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView?.backgroundColor = Color.LIGHTGREY.toUIColor()

        collectionView?.dataSource = self
        collectionView?.delegate = self
       
        multiButton = UIBarButtonItem(title: "Auswählen", style: UIBarButtonItemStyle.Plain, target: self, action: "select:")
        doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done:")
       
        collectionView?.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeRightTwoFingers)
        collectionView?.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeLeftTwoFingers)
        collectionView?.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeUpTwoFingers)
        collectionView?.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeDownTwoFingers)
        
        self.navigationItem.rightBarButtonItem = multiButton
        if (album != nil) {
            self.title = album.valueForProperty(ALAssetsGroupPropertyName) as? String
            loadPhotos()
        } else {
            collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> PhotoCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as PhotoCell
        cell.asset = photos[indexPath.row]
        cell.imageView.image = UIImage(CGImage: cell.asset.thumbnail().takeUnretainedValue())
        for (index, view) in enumerate(Global.carousel.items) {
            if (view == cell) {
                cell.highlight()
            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (!multiSelect) {
            var photoGalerieViewController = PhotoGallerieViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
            photoGalerieViewController.currentIndex = indexPath.row
            photoGalerieViewController.photos = photos
            navigationController?.pushViewController(photoGalerieViewController, animated: true)
        } else {
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as PhotoCell
            if (!cell.isHighlighted) {
                cell.highlight()
                var copyCell = cell.copy() as PhotoCell
                Global.carousel.items.insert(copyCell, atIndex: 0)
                Global.carousel.insertItemAtIndex(0, animated: true)
            } else {
                for (index, view) in enumerate(Global.carousel.items) {
                    if (view == cell) {
                        Global.carousel.items.removeAtIndex(index)
                        var carouselIndex = Global.carousel.indexOfItemView(view)
                        Global.carousel.removeItemAtIndex(carouselIndex, animated: true)
                    }
                }
                cell.unHighlight()
            }
        }
    }

    
    func loadPhotos() {
        album.enumerateAssetsUsingBlock { (result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            if result != nil {
                self.photos.append(result)
            }
        }
    }
    
    override func select(sender: AnyObject?) {
        multiSelect = true
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func done(sender: AnyObject?) {
        multiSelect = false
        self.navigationItem.rightBarButtonItem = multiButton
    }
}