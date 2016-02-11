//
//  AppDelegate.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 19/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import CoreData
//import Fabric
//import Crashlytics
import Material


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
		//Fabric.with([Crashlytics.self()])
		model.preloadData()
		let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		dispatch_async(dispatchQueue, {
			Networking.sharedInstance.updateAll(nil)
		})
		UIApplication.sharedApplication().statusBarStyle = .Default
		//UITabBar.appearance().tintColor = UIColor(rgba: "#5D8642")
		UINavigationBar.appearance().barTintColor = MaterialColor.green.darken1
		UINavigationBar.appearance().tintColor = UIColor.whiteColor()
		UINavigationBar.appearance().barStyle = UIBarStyle.Black
		
		let barShadow: NSShadow = NSShadow()
		barShadow.shadowColor = MaterialColor.green.darken2
		barShadow.shadowOffset = CGSize(width: 1, height: 1)
		barShadow.shadowBlurRadius = CGFloat(5.0)
		
		UINavigationBar.appearance().titleTextAttributes = [
			NSForegroundColorAttributeName:UIColor.whiteColor(),
			NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!,
			NSShadowAttributeName: barShadow
		]
		UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
		
		application.setMinimumBackgroundFetchInterval(21600) // 6 hours
		
		self.window?.makeKeyAndVisible()
		return true
    }

	
	func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
		Networking.sharedInstance.backgroundCompletionHandler = completionHandler
	}
	
	
	func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		Networking.sharedInstance.updateAll({(data:AnyObject?) in
			if data != nil {
				completionHandler(.NewData)
			} else {
				completionHandler(.Failed)
			}
		})
	}
	
	
	func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
		return false
	}
	
	
	func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
		return false
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
        // Saves changes in the application's managed object context before the application terminates.
        //CurrencyModel().saveStorage()
    }
	

	lazy var model: Model = {
		return Model()
	}()
}

