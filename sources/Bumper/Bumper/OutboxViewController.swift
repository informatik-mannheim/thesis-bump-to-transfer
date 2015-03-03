//
//  OutboxViewController.swift
//  Bumper
//
//  Created by Benjamin on 25/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//


import Foundation
import UIKit

class OutboxViewController: BrowserViewController {
    
    let browserContentViewController = BrowserContentViewController(nibName: nil, bundle: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.LIGHTGREY.toUIColor()
        view.frame = Global.browserBounds
        
        Global.carousel = Carousel(frame: Global.browserTopCarouselFrame)
        Global.carousel.type = .CoverFlow2
        view.addSubview(Global.carousel)
        
        header = UIView(frame: Global.browserHeaderFrame)
        let headerMaskLayer = CAShapeLayer()
        headerMaskLayer.path = UIBezierPath(roundedRect: header.bounds, byRoundingCorners: .TopLeft | .TopRight, cornerRadii: CGSize(width: 8.0,    height:8.0)).CGPath
        header.layer.mask = headerMaskLayer
        
        footer = UIView(frame: Global.browserFooterFrame)
        let footerMaskLayer = CAShapeLayer()
        footerMaskLayer.path = UIBezierPath(roundedRect: footer.bounds, byRoundingCorners: .BottomLeft | .BottomRight, cornerRadii: CGSize(width: 8.0,  height: 8.0)).CGPath
        footer.layer.mask = footerMaskLayer

        header.backgroundColor = Color.DARKGREY.toUIColor()
        footer.backgroundColor = Color.DARKGREY.toUIColor()
        
        addChildViewController(browserContentViewController)
        view.addSubview(browserContentViewController.view)
        view.addSubview(header)
        view.addSubview(footer)
        
    }

}