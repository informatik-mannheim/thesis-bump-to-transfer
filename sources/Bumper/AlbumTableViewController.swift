//
//  AlbumTableViewController.swift
//  Bumper
//
//  Created by Benjamin on 17/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class AlbumTableViewController: UITableViewController {
    
    var albums : [ALAssetsGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.title = "Alben"
        self.tableView.rowHeight = Global.itemSize.height
        self.tableView.separatorColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsetsMake(2.5, -15, 2.5, 0)
        if (albums.isEmpty) {
            loadAlbums()
        }
        
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeRightTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeLeftTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeUpTwoFingers)
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(Global.swipeDownTwoFingers)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"Cell")
        cell.backgroundColor = UIColor.clearColor()
        cell.imageView?.image = UIImage(CGImage: albums[indexPath.row].posterImage().takeUnretainedValue())
        cell.textLabel?.text = albums[indexPath.row].valueForProperty(ALAssetsGroupPropertyName) as? String
        cell.detailTextLabel?.text = String(albums[indexPath.row].numberOfAssets())
        cell.accessoryType = .DisclosureIndicator
        var selectedView =  UITableViewCell(frame: cell.frame)
        selectedView.backgroundColor = Color.BLUE.toUIColor()
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: Global.padding, left: 0, bottom: Global.padding, right: 0)
        layout.minimumInteritemSpacing = Global.padding
        layout.minimumLineSpacing = Global.padding
        layout.itemSize = Global.itemSize
        
        var photoCollection = PhotoCollectionViewController(collectionViewLayout: layout)
        photoCollection.album = albums[indexPath.row]
        navigationController?.pushViewController(photoCollection, animated: true)
    }
    
    func loadAlbums() {
        dispatch_async(dispatch_get_main_queue(), {
            Global.assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupSavedPhotos),
                usingBlock: {
                    (group: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    if group != nil {
                       self.albums.append(group)
                    }
                    self.tableView.reloadData()

                },
                failureBlock: {
                    (myerror: NSError!) -> Void in
                    println("error occurred: \(myerror.localizedDescription)")
            })
            Global.assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupAlbum),
                usingBlock: {
                    (group: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    if group != nil {
                        self.albums.append(group)
                    }
                    self.tableView.reloadData()
                },
                failureBlock: {
                    (myerror: NSError!) -> Void in
                    println("error occurred: \(myerror.localizedDescription)")
            })
        })
    }
}