//
//  UIView+Extensions.swift
//  TabBarDemo
//
//  Created by fenrir-cd on 17/2/8.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

internal extension UIView{
    class func custom_ViewFromNib() -> Self{
        return self.custom_ViewFromNib(withOwner: nil)
    }
    class func custom_ViewFromNib(withOwner owner:Any?) -> Self{
        let name = NSStringFromClass(self as! AnyClass).components(separatedBy: ".").last!
        let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: owner, options: nil).first!
        return cast(view)!
    }
    func custom_loadFromNibIfEmbeddedInDifferentNib() -> Self {
        
        let isJustAPlaceholder = self.subviews.count == 0
        if isJustAPlaceholder {
            let theRealThing = type(of: self).custom_ViewFromNib(withOwner: nil)
            theRealThing.frame = self.frame
            self.translatesAutoresizingMaskIntoConstraints = false
            theRealThing.translatesAutoresizingMaskIntoConstraints = false
            return theRealThing
        }
        return self
    }
}
private func cast<T,U>(_ value:T) -> U?{
    return value as? U
}
