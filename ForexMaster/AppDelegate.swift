//
//  AppDelegate.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window!.rootViewController = UIViewController()
        window!.makeKeyAndVisible()
        AppDelegate.launchAppControllers()
        
        // Additional setup
        setupNavBar()
        
        // Firebase
        FIRApp.configure()
        
        // Push notifications
        registerForPushNotifications(application)
        
        return true
    }
    
    class func createMainTabBarController() -> MainTabBarController {
        // add feed view controller and settings view controller
        
        let accountSummaryViewController = AccountSummaryViewController(nibName: "AccountSummaryViewController", bundle: nil)
        let accountSummaryNavigationViewController = UINavigationController(rootViewController: accountSummaryViewController)
        accountSummaryNavigationViewController.tabBarItem.image = UIImage(named: "performance.png")
        accountSummaryNavigationViewController.title = "Account"
        
        let positionsViewController = PositionsViewController(nibName: "PositionsViewController", bundle: nil)
        let positionsNavigationViewController = UINavigationController(rootViewController: positionsViewController)
        positionsNavigationViewController.tabBarItem.image = UIImage(named: "portfolio.png")
        positionsNavigationViewController.title = "Portfolio"
        
        let historyViewController = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
        let historyNavigationViewController = UINavigationController(rootViewController: historyViewController)
        historyNavigationViewController.tabBarItem.image = UIImage(named: "history.png")
        historyNavigationViewController.title = "History"
        
        let tabBarControllers = [accountSummaryNavigationViewController, positionsNavigationViewController, historyNavigationViewController]
        
        let mainTabBarController = MainTabBarController()
        mainTabBarController.viewControllers = tabBarControllers
        
        return mainTabBarController
    }
    
    func setupSegmentedControl() {
        UISegmentedControl.appearance().tintColor = Styles.Colors.Green
    }
    
    func setupNavBar() {
        let topBarTextAttributes = [
            NSForegroundColorAttributeName: Styles.Colors.Black,
            NSFontAttributeName: Styles.Fonts.avenirMediumFontWithSize(18)
        ]
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = Styles.Colors.Black
        navigationBarAppearance.barTintColor = Styles.Colors.White
        
        navigationBarAppearance.titleTextAttributes = topBarTextAttributes
        navigationBarAppearance.barStyle = .Default
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes(topBarTextAttributes, forState: .Normal)
    }
    
    class func launchAppControllers() {
        let mainTabBarController = createMainTabBarController()
        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootViewController?.presentViewController(mainTabBarController, animated: true, completion: nil)
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
        application.applicationIconBadgeNumber = 0
        if let pushToken = NSUserDefaults.standardUserDefaults().objectForKey("pushToken") as? String {
            let baseUrl = NetworkManager.sharedInstance.baseUrl
            let url = "\(baseUrl)/clear_badge_count/\(pushToken).json"
            
            let request = Alamofire.request(.POST, url, parameters: nil, encoding: .JSON)
            request.responseJSON { (response) in
                print(response)
            }
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        // What if the user declines the permissions?
        // When the user accepts or declines your permissions or has already made that selection in the past, this gets called
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        // Set push token
        NSUserDefaults.standardUserDefaults().setObject(tokenString, forKey: "pushToken")
        
        print("Device Token:", tokenString)
        let baseUrl = NetworkManager.sharedInstance.baseUrl
        let url = "\(baseUrl)/register_token/\(tokenString).json"

        let request = Alamofire.request(.POST, url, parameters: nil, encoding: .JSON)
        request.responseJSON { (response) in
            print(response)
        }
    }
}

