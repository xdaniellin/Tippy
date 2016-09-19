//
//  AppDelegate.swift
//  Tippy
//
//  Created by Daniel Lin on 7/16/16.
//  Copyright (c) 2016 Daniel Lin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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
    
    // Tutorial used: https://www.youtube.com/watch?v=NO9E5KxixOw
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController

        if let _navigationController = root as? UINavigationController
        {
            // If it's not the first time launching the app
            if _navigationController.viewControllers.count > 0
            {
                // Find the existing VC and call the "setTipString" method from it
                if let _viewController = _navigationController.viewControllers.first as? ViewController
                {
                    // Call "setTipString"
                    _viewController.setTipString(shortcutItem.type)                }
            }
            // If first time launching app
            else
            {
                //We have to call the "tipVC.setTipString" method only after the VC is loaded
                let tipVC = sb.instantiateViewControllerWithIdentifier("tipVC") as! ViewController
                root?.presentViewController(tipVC, animated: true, completion: { () -> Void in
                    tipVC.setTipString(shortcutItem.type)
                    completionHandler(true)
                })
            }
        }
    }


}

