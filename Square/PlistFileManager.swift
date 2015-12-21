//
//  PlistFileManager.swift
//  Square
//
//  Created by Bers on 15/11/8.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

class PlistFileManager: NSObject {
    
    var data: NSDictionary!
    
    class var sharedManager : PlistFileManager {
        return sharedInstance
    }
    
    override init() {
        super.init()
        let plistPath = NSBundle.mainBundle().pathForResource("ObjectsInformation", ofType: "plist")
        self.data = NSDictionary(contentsOfFile: plistPath!)
    }
    
    func identifierCode(forFileName name: String) -> Float {
        let keys = data.allKeys as! [String]
        for key in keys {
            if self.fileName(forIdentifier: Float(key)!) == name {
                return Float(key)!
            }
        }
        return Float(100)
    }
    
    func fileName(forIdentifier code: Float) -> String?{
        let intCode = Int(code)
        let dict = self.data[String(intCode)] as! NSDictionary
        return dict["FileName"] as? String
    }
    
    func title(forIdentifier code: Float) -> String{
        let intCode = Int(code)
        let dict = self.data[String(intCode)] as! NSDictionary
        return dict["Title"] as! String
    }
    
    func description(forIdentifier code: Float) -> String{
        let intCode = Int(code)
        let dict = self.data[String(intCode)] as! NSDictionary
        return dict["Description"] as! String
    }
}

private let sharedInstance = PlistFileManager()
