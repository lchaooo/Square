//
//  DotPropertySlider.swift
//  Square
//
//  Created by Bers on 15/12/13.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

@IBDesignable class DotPropertySlider: UIControl {

    @IBInspectable var value : CGFloat = CGFloat(0.5)
    @IBInspectable var minValue : CGFloat = CGFloat(0.0)
    @IBInspectable var maxValue : CGFloat = CGFloat(1.0)
    @IBInspectable var dotRadius : CGFloat = CGFloat(1.5)
    @IBInspectable var lineColor : UIColor = UIColor.blackColor()
    @IBInspectable var dotColor : UIColor = UIColor.blackColor()
    
    var dot : UIView!
    var panGesture : UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitInit()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commitInit()
    }
    
    func commitInit() {
        self.panGesture = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
    }
    
    func handlePan(sender:UIPanGestureRecognizer) {
        let location = sender.locationInView(self)
        self.dot.center = CGPointMake(location.x, self.dot.center.y)
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    override func layoutSubviews() {
        self.value.restrictInRange(self.minValue, self.maxValue)
        var portion = CGFloat((self.value - self.minValue) / (self.maxValue - self.minValue))
        portion.restrictInRange(0.0, 1.0)
        self.dot = UIView(frame: CGRectMake(0, 0, self.dotRadius*2, self.dotRadius*2))
        self.dot.center = CGPointMake((self.bounds.size.width-2*self.dotRadius)*portion + self.dotRadius, self.bounds.size.height / 2)
        self.dot.addGestureRecognizer(self.panGesture)
        self.addSubview(self.dot)
        let layer = CAShapeLayer()
        let dotPath = UIBezierPath()
        dotPath.addArcWithCenter(CGPointMake(self.dot.bounds.size.width / 2, self.dot.bounds.size.height / 2), radius: self.dotRadius, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        layer.path = dotPath.CGPath
        layer.fillColor = dotColor.CGColor
        self.dot.layer.addSublayer(layer)
    }
    
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(self.dotRadius, self.bounds.size.height / 2))
        path.addLineToPoint(CGPointMake(self.bounds.size.width - self.dotRadius, self.bounds.size.height / 2))
        path.lineWidth = 1.0
        lineColor.set()
        path.stroke()
    }
    
}
