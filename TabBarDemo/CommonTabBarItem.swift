//
//  CommonTabBarItem.swift
//  TabBarDemo
//
//  Created by fenrir-cd on 17/2/9.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

class CommonTabBarItem: TabBarItemView {

    @IBOutlet weak var imageview: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = selected ? UIColor.green : UIColor.lightGray
    }
}
