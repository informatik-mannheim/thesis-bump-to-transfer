//
//  TableViewCell.swift
//  Bumper
//
//  Created by Benjamin on 18/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        imageView.frame = CGRectMake(0, 0, frame.height, frame.width)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}