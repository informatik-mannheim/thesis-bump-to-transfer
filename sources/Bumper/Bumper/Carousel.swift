//
//  Carousel.swift
//  Bumper
//
//  Created by Benjamin on 04/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import Foundation
import UIKit

class Carousel: iCarousel, iCarouselDataSource, iCarouselDelegate {
    
    var items: [PhotoCell] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dataSource = self
        delegate = self
        self.clipsToBounds = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        return items.count
    }
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        println("tap")
        println(carousel.itemViewAtIndex(index))
    }

    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView!
    {
        view = items[0]
        view.frame = CGRectMake(0, 0, Global.itemSize.width, Global.itemSize.height)
        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 1.1
        }
        if (option == .VisibleItems)
        {
            return CGFloat(items.count+3)
        }
        return value
    }
    
    
    func  carousel(carousel: iCarousel!, placeholderViewAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        var view = UIView(frame: CGRectMake(0, 0, Global.itemSize.width, Global.itemSize.height))
        return view
    }
    
    func numberOfPlaceholdersInCarousel(carousel: iCarousel!) -> Int {
        return 6
    }
    
    func contains(photo: FullSizePhoto) -> Bool {
        var found = false
        var index = 0
        while (!found && index < items.count) {
            var view = items[index]
            if (view == photo) {
            found = true
            } else {
                index++
            }
        }
        return found
    }
     
}