//
//  AppDelegate.swift
//  volunteam
//
//  Created by Ryan Wolande on 11/11/15.
//  Copyright © 2015 Ryan Wolande. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        var tab_controller: tab_bar_controller?
        var sign_up_controller: sign_up_view_controller?
        var location_manager: CLLocationManager?
        
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
                
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.window!.backgroundColor = UIColor.whiteColor()
                
                self.assign_root_as_tab()
                return true
        }
        
        func assign_root_as_tab()
        {
                if let user_info = NSUserDefaults.standardUserDefaults().objectForKey("user_info") as? Dictionary<String,AnyObject>
                {
                        if let user = rmw_user(raw: user_info)
                        {
                                rmw_user.shared_instance = user
                        }
                }
                
                if rmw_user.shared_instance.signed_in
                {
                        if self.tab_controller == nil
                        {
                                
                                self.tab_controller = tab_bar_controller()
                        }
                        UIView.beginAnimations(nil, context: nil)
                        UIView.setAnimationDuration(0.3)
                        UIView.setAnimationCurve(.EaseInOut)
                        UIView.setAnimationBeginsFromCurrentState(true)
                        self.window!.rootViewController = self.tab_controller
                        self.window!.makeKeyAndVisible()
                        UIView.commitAnimations()
                }
                else
                {
                        if self.sign_up_controller == nil
                        {
                                
                                self.sign_up_controller = sign_up_view_controller()
                        }
                        UIView.beginAnimations(nil, context: nil)
                        UIView.setAnimationDuration(0.3)
                        UIView.setAnimationCurve(.EaseInOut)
                        UIView.setAnimationBeginsFromCurrentState(true)
                        self.window!.rootViewController = self.sign_up_controller
                        self.window!.makeKeyAndVisible()
                        UIView.commitAnimations()
                }
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

