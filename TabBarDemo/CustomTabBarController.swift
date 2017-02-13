//
//  CustomTabBarController.swift
//  TabBarDemo
//
//  Created by fenrir-cd on 17/2/8.
//  Copyright © 2017年 fenrir CD. All rights reserved.
//

import UIKit

private let defaultHeight: CGFloat = 49

// MARK:TabBarItemView
class TabBarItemView: UIView {
    
    var heightValue:CGFloat?
    var preferedHeight:CGFloat {
        return heightValue ?? _preferedHeight
    }
    
    fileprivate var _preferedHeight:CGFloat = defaultHeight
    fileprivate weak var heightConstraint:NSLayoutConstraint!
    fileprivate(set) var index:Int = 0
    private var _isSelected:Bool = false
    var isSelected:Bool {
        return _isSelected
    }
    
    func setSelected(_ selected: Bool, animated: Bool) {
        _isSelected = selected
    }
    
    static func loadViewFromNib() -> Self{
        return self.init().custom_loadFromNibIfEmbeddedInDifferentNib()
    }
    
}

// MARK:TabBarItem
class TabBarItem:UITabBarItem{
    fileprivate var containerView:TabBarItemView!
    
    var index:Int {
        return containerView.index
    }
    var isSelected:Bool{
        return containerView.isSelected
    }
    
    fileprivate func setSelected(_ selected: Bool, animated: Bool) {
        containerView.setSelected(selected, animated: animated)
    }
}
// MARK:TabBar
class TabBar:UITabBar {
    fileprivate var preferedHeight:CGFloat = defaultHeight
    fileprivate weak var tabBarController:CustomTabBarController?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for item in tabBarController?.cItems ?? [] {
            if item.containerView.frame.contains(point) {
                return true
            }
        }
        return super.point(inside: point, with: event)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = preferedHeight
        return size
    }
    override var alpha: CGFloat{
        didSet{
            for view in subviews {
                if view is TabBarItemView {
                    view.alpha = alpha
                }else{
                    view.alpha = 0.0
                }
            }
        }
    }
    override func addSubview(_ view: UIView) {
        if view is TabBarItemView {
            super.addSubview(view)
        }else{
            super.insertSubview(view, at: 0)
        }
    }
}
// MARK: UIViewController
extension UIViewController {
    func cTabBarItemContentView() -> TabBarItemView {
        fatalError("Must be implemented in subclass")
    }
    public var cTabBarController: CustomTabBarController? {
        return self.tabBarController as? CustomTabBarController
    }
}
public class CustomTabBarController: UITabBarController {

    var preferedHeight:CGFloat = defaultHeight{
        didSet{
            cTabBar.preferedHeight = preferedHeight
            view.setNeedsLayout()
            selectedViewController?.view.setNeedsLayout()
        }
    }
    var cTabBar:TabBar {
        return self.tabBar as! TabBar
    }
    var cItems:[TabBarItem]{
        let items = self.tabBar.items as? [TabBarItem]
        return items ?? []
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for item in cItems {
            item.containerView._preferedHeight = self.preferedHeight
            item.containerView.heightConstraint.constant = item.containerView.preferedHeight
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        assert(tabBar is TabBar, "tabBar class must be `TabBar` class")

        cTabBar.tabBarController = self
        createViewContainers()
    }
    func createViewContainers() {
        for (index,item) in cItems.enumerated() {
            let viewContainer = setupView(onItem: item, index: index)
            if index == 0 {
                item.setSelected(true, animated: false)
            }else{
                item.setSelected(false, animated: false)
            }
            tabBar.addSubview(viewContainer)
            tabBar.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
            if index > 0 {
                cItems[index - 1].containerView.rightAnchor.constraint(equalTo: viewContainer.leftAnchor).isActive = true
                cItems[index - 1].containerView.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
            }
        }
        if let fristItem = cItems.first,let lastItem = cItems.last{
            tabBar.leftAnchor.constraint(equalTo: fristItem.containerView.leftAnchor).isActive = true
            tabBar.rightAnchor.constraint(equalTo: lastItem.containerView.rightAnchor).isActive = true
            
        }
        tabBar.alpha = 1
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
    }

    func setupView(onItem item:TabBarItem,index:Int) -> TabBarItemView {
       let viewContainer = self.tabBarItem(forViewController: (self.viewControllers?[index])!)
        viewContainer.index = index
        viewContainer._preferedHeight = self.preferedHeight
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(CustomTabBarController.tapHandler(_:)))
        tapGesture.minimumPressDuration = 0
        viewContainer.addGestureRecognizer(tapGesture)
        viewContainer.heightConstraint = viewContainer.heightAnchor.constraint(equalToConstant: viewContainer.preferedHeight)
        viewContainer.heightConstraint.isActive = true
        item.containerView = viewContainer
        return viewContainer
    }
    func tabBarItem(forViewController viewController:UIViewController) -> TabBarItemView {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first?.cTabBarItemContentView() ?? viewController.cTabBarItemContentView()
        }
        return viewController.cTabBarItemContentView()
    }
    
    func tapHandler(_ gesture:UIGestureRecognizer){
        let currentIndex = (gesture.view as! TabBarItemView).index
        setSelectedIndex(currentIndex)
    }
    private func setSelectedIndex(_ currentIndex: Int) {
        if selectedIndex != currentIndex {
            let selectedItem: TabBarItem = cItems[currentIndex]
            selectedItem.setSelected(true, animated: true)
            
            let deselectedItem = cItems[selectedIndex]
            deselectedItem.setSelected(false, animated: true)
            
            selectedIndex = currentIndex
        }
    }
}
