//
//  BSDrawerContainer.swift
//  BSDrawerController
//
//  Created by Bers on 15/12/2.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

let BSDrawerMajorColor = UIColor(red: 255.0/255.0, green: 223.0/255.0, blue: 183.0/255.0, alpha: 1.0)
let BSDrawerHighlightedColor = UIColor(red: 239.0/255.0, green: 181.0/255.0, blue: 115.0/255.0, alpha: 1.0)
let BSDrawerTextColor = UIColor(red: 187.0/255.0, green: 154.0/255.0, blue: 116.0/255.0, alpha: 1.0)

class BSDrawerContainer: UIViewController {
    
    struct DrawerOptions {
        static var leftWidth = CGFloat(300.0);
        static var animationDuration = 0.3;
        static var defaultViewControllerIndex = 0;
        static var panGestrueEnabled = false;
    }
    
    private var leftViewController : BSDrawerLeftViewController!
    var viewControllers : [UIViewController]!;
    var titles : [String]!{
        didSet{
            self.leftViewController.menuItemTitles = titles
        }
    }
    var currentSelection = DrawerOptions.defaultViewControllerIndex
    var currentPresentedVC : UIViewController!
    var leftViewControllerHasShown = false
    let switchImg = UIImage(named: "Switch.png")?.imageWithRenderingMode(.AlwaysTemplate)
    let backImg = UIImage(named: "Back.png")?.imageWithRenderingMode(.AlwaysTemplate)
    var tapGesture = UITapGestureRecognizer()
    lazy var switchButton : UIButton = {
        var button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(10, 31, 50, 50)
        button.setImage(self.switchImg, forState: .Normal)
        button.tintColor = BSDrawerMajorColor
        button.trigger({ [unowned self] (button) -> Void in
            self.showLeftViewController()
        }, onEvent: .TouchUpInside)
        return button
    }()
    
    init(viewControllers: [UIViewController], titles: [String]){
        assert(viewControllers.count == titles.count)
        super.init(nibName: nil, bundle: nil);
        self.commitInit()
        self.leftViewController.menuItemTitles = titles
        self.viewControllers = viewControllers
    }
    
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.commitInit()
        self.viewControllers = [UIViewController]();
    }
    
    func commitInit(){
        self.leftViewController = BSDrawerLeftViewController()
        self.leftViewController.delegate = self
        self.leftViewController.tableViewWidth = DrawerOptions.leftWidth
        self.leftViewController.currentSelection = DrawerOptions.defaultViewControllerIndex
        let titleView = UILabel()
        titleView.text = "一 方"
        titleView.textColor = UIColor(white: 96.0/255.0, alpha: 1.0)
        titleView.font = UIFont.systemFontOfSize(36)
        titleView.sizeToFit()
        self.leftViewController.topView = titleView
        self.addChildViewController(self.leftViewController)
        self.tapGesture.addTarget(self, action: Selector("handleTap:"))
        self.tapGesture.enabled = false
        self.tapGesture.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.viewControllers.count != 0)
        self.view.addGestureRecognizer(self.tapGesture)
        let vcToPresent = self.viewControllers[self.currentSelection]
        self.presentChildViewCotnroller(vcToPresent)
        
    }
    
    func showLeftViewController() {
        self.currentPresentedVC.view.userInteractionEnabled = false
        self.leftViewController.beginAppearanceTransition(true, animated: true)
        self.view.insertSubview(self.leftViewController.view, atIndex: 0)
        UIView.animateWithDuration(DrawerOptions.animationDuration, animations: { () -> Void in
            self.currentPresentedVC.view.addCenterX(DrawerOptions.leftWidth)
        }) { (finished) -> Void in
            self.leftViewController.endAppearanceTransition()
            self.leftViewController.didMoveToParentViewController(self)
            self.leftViewControllerHasShown = true
            self.tapGesture.enabled = true
            self.switchButton.setImage(self.backImg, forState: .Normal)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideLeftViewController(changed:Bool ,closure:(()->Void)?) {
        self.leftViewController.beginAppearanceTransition(true, animated: true)
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            if changed {
               self.currentPresentedVC.view.addCenterX(30)
            }
        }) { (finished) -> Void in
            closure?();
            UIView.animateWithDuration(DrawerOptions.animationDuration, animations: { () -> Void in
                self.currentPresentedVC.view.addCenterX(-DrawerOptions.leftWidth - (changed ? 30 : 0))
                }) { (finished) -> Void in
                    self.currentPresentedVC.view.userInteractionEnabled = true
                    self.leftViewController.endAppearanceTransition()
                    self.leftViewController.view.removeFromSuperview()
                    self.leftViewController.removeFromParentViewController()
                    self.leftViewControllerHasShown = false
                    self.tapGesture.enabled = false
                    self.switchButton.setImage(self.switchImg, forState: .Normal)
            }

        }
    }
    
    func handleTap(sender: UITapGestureRecognizer){
        self.hideLeftViewController(false, closure: nil)
    }
    
}

extension BSDrawerContainer: BSDrawerSelectionDelegate, UIGestureRecognizerDelegate {
    func presentChildViewCotnroller(controller:UIViewController){
        controller.beginAppearanceTransition(true, animated: false)
        self.view.addSubview(controller.view)
        controller.endAppearanceTransition()
        controller.didMoveToParentViewController(self)
        controller.view.addSubview(self.switchButton)
        self.currentPresentedVC = controller
    }
    
    func didSelectedItemAtIndex(index: Int) {
        if index == self.currentSelection {
            self.hideLeftViewController(false, closure: nil)
            return
        }
        self.hideLeftViewController(true) {
            self.currentPresentedVC.willMoveToParentViewController(nil)
            self.currentPresentedVC.beginAppearanceTransition(false, animated: false)
            self.currentPresentedVC.view.removeFromSuperview()
            self.currentPresentedVC.endAppearanceTransition()
            self.currentPresentedVC.removeFromParentViewController()
            self.currentPresentedVC.view.addCenterX(-DrawerOptions.leftWidth-30)
            self.presentChildViewCotnroller(self.viewControllers[index])
            self.currentPresentedVC.view.addCenterX(DrawerOptions.leftWidth+30)
            self.currentSelection = index
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
       return touch.locationInView(self.currentPresentedVC.view).x > 0
    }
}