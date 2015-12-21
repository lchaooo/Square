//
//  AppDelegate.swift
//  Square
//
//  Created by Bers on 15/12/6.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let dataManager = ProjectionFMDBDataManager()
        let rootVC = self.window?.rootViewController as! BSDrawerContainer
        let preview = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("PreviewController") as! UINavigationController
        let previewVC = preview.viewControllers[0] as! PreviewViewController
        rootVC.viewControllers = [preview]
        rootVC.titles = ["预览"]
        previewVC.dataManager = dataManager
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var filePath = NSURL(string: path[0] + "/ModelImages/checkmark.png")
        let model = ProjectionLocalModel(identifier: "Checkmark", filePath: filePath!, title: "checkmark", description: "Test checkmark", previewImagePath: filePath!)
        filePath = NSURL(string: path[0] + "/ModelImages/favicon.png")
        let model2 = ProjectionLocalModel(identifier: "Favicon", filePath: filePath!, title: "favicon", description: "Test favicon", previewImagePath: filePath!)
        filePath = NSURL(string: path[0] + "/ModelImages/soundDisabled.png")
        let model3 = ProjectionLocalModel(identifier: "SoundDisabled", filePath: filePath!, title: "soundDisabled", description: "Test soundDisabled", previewImagePath: filePath!)
        do {
            try dataManager.addProjectionLocalModel(model)
            try dataManager.addProjectionLocalModel(model2)
            try dataManager.addProjectionLocalModel(model3)
        } catch DataManagerError.IdentifierAlreadyExist {
            print("ERROR!")
        } catch {
            
        }
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

