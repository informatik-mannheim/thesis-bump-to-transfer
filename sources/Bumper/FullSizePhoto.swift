//
//  FullSizePhoto.swift
//  Bumper
//
//  Created by Benjamin on 24/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class FullSizePhoto: UIView {
    
    var asset: ALAsset!
    let imageView: UIImageView!
    var isHighlighted = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        addSubview(imageView)
    }
    
    init(frame: CGRect, asset: ALAsset) {
        super.init(frame: frame)
        self.asset = asset
        imageView = UIImageView(frame: frame)
        imageView.image = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy() -> AnyObject {
        var copy = PhotoCell(frame: self.frame, asset: self.asset)
        return copy
    }
    
    func equals(photoCell: PhotoCell) -> Bool{
        return self.asset.defaultRepresentation().url() == photoCell.asset.defaultRepresentation().url()
    }
    
    //    func equals(fullSizePhote: PhotoViewController) -> Bool {
    //        return self.asset.defaultRepresentation().url() == fullSizePhote.pageIndex
    //    }
    
    func highlight() {
        alpha = 0.5
        isHighlighted = true
    }
    
    func unHighlight() {
        alpha = 1.0
        isHighlighted = false
    }

    
}
