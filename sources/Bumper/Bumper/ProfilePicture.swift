//
//  ProfilePicture.swift
//  Bumper
//
//  Created by Benjamin on 25/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation

class ProfilePicture: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.MEDIUMGREY.toUIColor()
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true;
        self.userInteractionEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}