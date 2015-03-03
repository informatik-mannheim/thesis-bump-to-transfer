//
//  PhoneOwnerContactViewController.swift
//  Bumper
//
//  Created by Benjamin on 27/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation

class PhoneOwnerContactViewController: UINavigationController {
        
    override func viewDidLoad() {
        view.frame = Global.browserBounds
        view.backgroundColor = Color.DARKGREY.toUIColor()
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(1, 1)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 1.0
        
        //        header = UIView(frame: Global.browserHeaderFrame)
        //        let headerMaskLayer = CAShapeLayer()
        //        headerMaskLayer.path = UIBezierPath(roundedRect: header.bounds, byRoundingCorners: .TopLeft | .TopRight, cornerRadii: CGSize(width: 8.0,    height:8.0)).CGPath
        //        header.layer.mask = headerMaskLayer
        //
        //        footer = UIView(frame: Global.browserFooterFrame)
        //        let footerMaskLayer = CAShapeLayer()
        //        footerMaskLayer.path = UIBezierPath(roundedRect: footer.bounds, byRoundingCorners: .BottomLeft | .BottomRight, cornerRadii: CGSize(width: 8.0,  height: 8.0)).CGPath
        //        footer.layer.mask = footerMaskLayer
        //
        //        header.backgroundColor = Color.LIGHTGREY.toUIColor()
        //        footer.backgroundColor = Color.LIGHTGREY.toUIColor()
        //
        //        view.addSubview(header)
        //        view.addSubview(footer)
        
        var contactTable = PhoneOwnerViewController()
        self.addChildViewController(contactTable)
    }
}