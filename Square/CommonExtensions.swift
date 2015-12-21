//
//  CommonExtensions.swift
//  BSDrawerController
//
//  Created by Bers on 15/12/5.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit
import ObjectiveC

class ClosureWrapper<Param, Ret> {
    var _cls: ((Param) -> Ret)?
    
    var closure: ((Param) -> Ret)? {
        return self._cls
    }
    
    init(_ closure: ((Param) -> Ret)?) {
        self._cls = closure
    }
}

private class TriggerdEventsHelper {
    var _event : UIControlEvents!
    
    var event : UIControlEvents {
        return self._event;
    }
    
    @objc func touchDownSelector() {
        self._event = .TouchDown;
    }
    
    @objc func touchDownRepeatSelector() {
        self._event = .TouchDownRepeat;
    }
    
    @objc func touchDragInsideSelector() {
        self._event = .TouchDragInside;
    }
    
    @objc func touchDragOutsideSelector() {
        self._event = .TouchDragOutside;
    }
    
    @objc func touchDragEnterSelector() {
        self._event = .TouchDragEnter;
    }
    
    @objc func touchDragExitSelector() {
        self._event = .TouchDragExit;
    }
    
    @objc func touchUpInsideSelector() {
        self._event = .TouchUpInside;
    }
    
    @objc func touchUpOutsideSelector() {
        self._event = .TouchUpOutside;
    }
    
    @objc func touchCancelSelector() {
        self._event = .TouchCancel;
    }
    
    @objc func valueChangedSelector() {
        self._event = .ValueChanged;
    }
    
    @objc func editingDidBeginSelector() {
        self._event = .EditingDidBegin;
    }
    
    @objc func editingChangedSelector() {
        self._event = .EditingChanged;
    }
    
    @objc func editingDidEndSelector() {
        self._event = .EditingDidEnd;
    }
    
    @objc func editingDidEndOnExitSelector() {
        self._event = .EditingDidEndOnExit;
    }
    
    
    func selectorForEvent(event:UIControlEvents) -> Selector {
        switch(event){
        case UIControlEvents.TouchDown:
            return Selector("touchDownSelector")
        case UIControlEvents.TouchDownRepeat:
            return Selector("touchDownRepeatSelector")
        case UIControlEvents.TouchDragInside:
            return Selector("touchDragInsideSelector");
        case UIControlEvents.TouchDragOutside:
            return Selector("touchDragOutsideSelector");
        case UIControlEvents.TouchDragEnter:
            return Selector("touchDragEnterSelector");
        case UIControlEvents.TouchDragExit:
            return Selector("touchDragExitSelector");
        case UIControlEvents.TouchUpInside:
            return Selector("touchUpInsideSelector");
        case UIControlEvents.TouchUpOutside:
            return Selector("touchUpOutsideSelector");
        case UIControlEvents.TouchCancel:
            return Selector("touchCancelSelector");
        case UIControlEvents.ValueChanged:
            return Selector("ealueChangedSelector");
        case UIControlEvents.EditingDidBegin:
            return Selector("editingDidBeginSelector");
        case UIControlEvents.EditingChanged:
            return Selector("editingChangedSelector");
        case UIControlEvents.EditingDidEnd:
            return Selector("editingDidEndSelector");
        case UIControlEvents.EditingDidEndOnExit:
            return Selector("editingDidEndOnExitSelector");
        default:
            return nil;
        }
        
    }
}

extension UIControl {
    
    struct AssociatedKey {
        static var ClosuresDictionary = "ClosuresDictionary"
        static var triggeredEvent = "TriggerdEvent"
    }
    
    private var bs_triggeredEvent : TriggerdEventsHelper!{
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.triggeredEvent) as? TriggerdEventsHelper
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKey.triggeredEvent, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var bs_closuresDictionary : [UInt : ClosureWrapper<UIControl, Void>]! {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.ClosuresDictionary) as? [UInt :ClosureWrapper<UIControl, Void>]
        }
        set{
            let dict = newValue as NSDictionary?
            objc_setAssociatedObject(self, &AssociatedKey.ClosuresDictionary, dict, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } 
    }
    
    @objc private func targetTriggered(target:UIControl, forEvent event: UIEvent){
        let closure = self.bs_closuresDictionary[self.bs_triggeredEvent.event.rawValue]
        if let cls = closure where cls.closure != nil {
            cls.closure!(self)
        }
    }
    
    public func trigger(closure:((UIControl)->Void), onEvent event:UIControlEvents){
        if self.bs_triggeredEvent == nil{
            self.bs_triggeredEvent = TriggerdEventsHelper()
        }
        if self.bs_closuresDictionary == nil {
            self.bs_closuresDictionary = [UInt : ClosureWrapper<UIControl, Void>]()
        }
        self.removeOnEvent(event)
        self.bs_closuresDictionary[event.rawValue] = ClosureWrapper<UIControl, Void>(closure);
        self.addTarget(self.bs_triggeredEvent, action: self.bs_triggeredEvent.selectorForEvent(event), forControlEvents: event)
        self.addTarget(self, action: Selector("targetTriggered:forEvent:"), forControlEvents: event)
    }
    
    public func removeOnEvent(event: UIControlEvents){
        self.bs_closuresDictionary.removeValueForKey(event.rawValue)
        self.removeTarget(self, action: Selector("targetTriggered:forEvent:"), forControlEvents: event)
    }
}

extension UIView{
    
    func addCenterX(offset: CGFloat){
        var center = self.center
        center.x += offset
        self.center = center
    }

    func addCenterY(offset: CGFloat){
        var center = self.center
        center.y += offset
        self.center = center
    }

    var width : CGFloat {
        return self.bounds.size.width
    }

    var height : CGFloat {
        return self.bounds.size.height
    }

    var originX : CGFloat {
        return self.frame.origin.x
    }

    var originY : CGFloat {
        return self.frame.origin.y
    }

}

extension SignedNumberType {
    
    mutating func restrictInRange(min:Self, _ max: Self){
        if self<min {
            self = min
        }
        if self>max {
            self = max
        }
    }
    
}


