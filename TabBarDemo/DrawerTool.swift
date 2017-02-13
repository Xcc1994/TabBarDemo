//
//  DrawerTool.swift
//  TabBarDemo
//
//  Created by fenrir-cd on 17/2/13.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

class DrawerTool: NSObject {
    fileprivate var maskView:UIView?
    fileprivate var nowTabViewX:CGFloat! = 0
    
    private static var drawerTool = DrawerTool()
    class func sharedDrawerTool() -> DrawerTool{
        return drawerTool
    }
    
    func addMaskView(withFrame frame:CGRect){
        maskView = UIView(frame:frame)
        maskView?.backgroundColor = UIColor.lightGray
        maskView?.isHidden = true
        self.maskView?.alpha = 0.2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DrawerTool.tapHandler(gesture:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawerTool.panGesture(gesture:)))
        maskView?.addGestureRecognizer(tapGesture)
        maskView?.addGestureRecognizer(panGesture)
        UIApplication.shared.keyWindow?.addSubview(maskView!)
    }
    private func hiddenLeftView(timeInterval time:TimeInterval){
        UIView.animate(withDuration: time, animations: {
            
            RootViewController.leftView.frame.origin.x = -ScreenSize.scrrenWidth*LeftViewScale.scale
            RootViewController.tabVC.view.frame.origin.x = 0
            self.maskView?.frame.origin.x = 0
            self.maskView?.alpha = 0.2
        }, completion: { _ in
            self.maskView?.isHidden = true
        })
    }
    func showLeftView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.maskView?.isHidden = false
            self.maskView?.alpha = 0.5
            self.maskView?.frame.origin.x = ScreenSize.scrrenWidth*LeftViewScale.scale
            RootViewController.leftView.frame.origin.x = 0
            RootViewController.tabVC.view.frame.origin.x = ScreenSize.scrrenWidth*LeftViewScale.scale
            
        }, completion: { _ in
            self.nowTabViewX = RootViewController.tabVC.view.frame.origin.x
        })
    }
    func tapHandler(gesture:UITapGestureRecognizer){
        hiddenLeftView(timeInterval: 0.3)
    }
    func panGesture(gesture:UIPanGestureRecognizer){
        let translation = gesture.translation(in: gesture.view).x
        if translation >= RootViewController.leftView.frame.width {
            hiddenLeftView(timeInterval: 0.15)
            return
        }else if (translation >= 0){
            return
        }
        switch gesture.state {
        case .began:
            break
        case .changed:
            print(translation)
            RootViewController.tabVC.view.frame.origin.x = nowTabViewX+translation
            self.maskView?.frame.origin.x = nowTabViewX+translation
            RootViewController.leftView.frame.origin.x = translation
            break
        case .cancelled:
            hiddenLeftView(timeInterval: 0.15)
            break
        case .ended:
            hiddenLeftView(timeInterval: 0.15)
            break
        case .failed:
            hiddenLeftView(timeInterval: 0.15)
            break
        default:
            break
        }
    }
    deinit {
        maskView?.removeFromSuperview()
    }
}
