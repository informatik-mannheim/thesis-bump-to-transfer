//
//  Color.swift
//  Bumper
//
//  Created by Benjamin on 06/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit

enum Color {
    case DARKGREY, MEDIUMGREY, LIGHTGREY, BLUE
    func toUIColor() -> UIColor {
        switch self {
        case .DARKGREY:
            return UIColor(red: 0x4A/255, green: 0x4A/255, blue: 0x4A/255, alpha: 1.0)
        case .MEDIUMGREY:
            return UIColor(red: 0x9B/255, green: 0x9B/255, blue: 0x9B/255, alpha: 1.0)
        case .LIGHTGREY:
            return UIColor(red: 0xD8/255, green: 0xD8/255, blue: 0xD8/255, alpha: 1.0)
        case .BLUE:
            return UIColor(red: 0x4A/255, green: 0x90/255, blue: 0xE2/255, alpha: 1.0)
        default:
            return UIColor.blackColor()
        }
    }
}