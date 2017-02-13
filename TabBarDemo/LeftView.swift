//
//  LeftView.swift
//  TabBarDemo
//
//  Created by fenrir-cd on 17/2/10.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

class LeftView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: -ScreenSize.scrrenWidth*LeftViewScale.scale, y: 0, width: ScreenSize.scrrenWidth*LeftViewScale.scale, height: ScreenSize.scrrenHeight)
        self.backgroundColor = UIColor.orange
    }


}

