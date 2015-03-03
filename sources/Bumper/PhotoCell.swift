//
//  PhotoCell.swift
//  Bumper
//
//  Created by Benjamin on 12/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class PhotoCell: UICollectionViewCell {
    
    var asset: ALAsset!
    let imageView: UIImageView!
    var isHighlighted = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
    }
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame:frame)
        imageView.image = image
    }
    
    convenience init(frame: CGRect, asset: ALAsset) {
        self.init(frame: frame)
        imageView.image = UIImage(CGImage: asset.thumbnail().takeUnretainedValue())
        self.asset = asset
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy() -> AnyObject {
        var copy = PhotoCell(frame: self.frame, asset: self.asset)
        return copy
    }
    
    func highlight() {
        alpha = 0.5
        isHighlighted = true
    }
    
    func unHighlight() {
        alpha = 1.0
        isHighlighted = false
    }
}

func == (cell1: PhotoCell, cell2: PhotoCell) -> Bool {
    return (cell1.asset.defaultRepresentation().url() == cell2.asset.defaultRepresentation().url())
}

func != (cell1: PhotoCell, cell2: PhotoCell) -> Bool {
    return !(cell1 == cell2)
}

func == (cell: PhotoCell, fullSizePhoto: FullSizePhoto) -> Bool {
    return (cell.asset.defaultRepresentation().url() == fullSizePhoto.asset.defaultRepresentation().url())
}

func != (cell: PhotoCell, fullSizePhoto: FullSizePhoto) -> Bool {
    return !(cell == fullSizePhoto)
}