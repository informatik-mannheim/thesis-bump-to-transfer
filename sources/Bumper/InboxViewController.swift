//
//  InboxViewController.swift
//  Bumper
//
//  Created by Benjamin on 28/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit

class InboxViewController: BrowserViewController {
    
    var carousel: Carousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("InboxViewDidLoad")
        view.backgroundColor = Color.DARKGREY.toUIColor()
        view.frame = Global.browserBounds
        
        carousel = Carousel(frame: Global.browserTopCarouselFrame)
        carousel.type = .CoverFlow2
        view.addSubview(Global.carousel)
        
        header = UIView(frame: Global.browserHeaderFrame)
        let headerMaskLayer = CAShapeLayer()
        headerMaskLayer.path = UIBezierPath(roundedRect: header.bounds, byRoundingCorners: .TopLeft | .TopRight, cornerRadii: CGSize(width: 8.0,    height:8.0)).CGPath
        header.layer.mask = headerMaskLayer
        
        footer = UIView(frame: Global.browserFooterFrame)
        let footerMaskLayer = CAShapeLayer()
        footerMaskLayer.path = UIBezierPath(roundedRect: footer.bounds, byRoundingCorners: .BottomLeft | .BottomRight, cornerRadii: CGSize(width: 8.0,  height: 8.0)).CGPath
        footer.layer.mask = footerMaskLayer
        
        header.backgroundColor = Color.LIGHTGREY.toUIColor()
        footer.backgroundColor = Color.LIGHTGREY.toUIColor()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: Global.padding, left: 0, bottom: Global.padding, right: 0)
        layout.minimumInteritemSpacing = Global.padding
        layout.minimumLineSpacing = Global.padding
        layout.itemSize = Global.itemSize

        
        view.addSubview(header)
        view.addSubview(footer)
    }
    
}