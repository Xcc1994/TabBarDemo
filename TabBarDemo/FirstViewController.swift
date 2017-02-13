//
//  FirstViewController.swift
//  TabBarDemo
//
//  Created by fenrir-cd on 17/2/9.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    override func cTabBarItemContentView() -> TabBarItemView {
        let tab = CommonTabBarItem.loadViewFromNib()
        tab.imageview.image = UIImage(named: "carrycot")
        return tab
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DrawerTool.sharedDrawerTool().addMaskView(withFrame: self.view.frame)
    }
    
    @IBAction func showLeftView(_ sender: UIBarButtonItem) {
        DrawerTool.sharedDrawerTool().showLeftView()
    }
    
    
}
