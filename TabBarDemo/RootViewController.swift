//
//  RootViewController.swift
//  TabBarDemo
//
//  Created by fenrir-cd on 17/2/10.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    static let tabVC:CustomTabBarController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
    static let leftView:LeftView = UINib(nibName: "LeftView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! LeftView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(RootViewController.leftView)
        
        self.addChildViewController(RootViewController.tabVC)
        self.view.addSubview(RootViewController.tabVC.view)
        
    }

}
