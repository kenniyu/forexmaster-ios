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


public struct UserDefaultKeys {
    static let kPushHint = "pushHint"
    static let kPushToken = "pushToken"
    static let kLastAckedLegal = "lastAckedLegal"
}

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
        
        if let _ = launchOptions {
            FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kOpenedAppThroughPushNotification, parameters: nil)
        }
        
        checkLegal()
        
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
        
        let notificationViewController = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        let notificationNavigationViewController = UINavigationController(rootViewController: notificationViewController)
        notificationNavigationViewController.tabBarItem.image = UIImage(named: "message.png")
        notificationNavigationViewController.title = "Messages"
        
        let historyViewController = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
        let historyNavigationViewController = UINavigationController(rootViewController: historyViewController)
        historyNavigationViewController.tabBarItem.image = UIImage(named: "history.png")
        historyNavigationViewController.title = "History"
        
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let settingsNavigationViewController = UINavigationController(rootViewController: settingsViewController)
        settingsNavigationViewController.tabBarItem.image = UIImage(named: "settings.png")
        settingsNavigationViewController.title = "Settings"
        
        let tabBarControllers = [accountSummaryNavigationViewController, positionsNavigationViewController, notificationNavigationViewController, historyNavigationViewController, settingsNavigationViewController]
        
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
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kAppEnteredBackground, parameters: nil)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kAppEnteredForeground, parameters: nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
        if let pushToken = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.kPushToken) as? String {
            let baseUrl = NetworkManager.sharedInstance.baseUrl
            let url = "\(baseUrl)/clear_badge_count/\(pushToken).json"
            
            let request = Alamofire.request(.POST, url, parameters: nil, encoding: .JSON)
            request.responseJSON { (response) in
                print(response)
            }
        }
        
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kAppEnteredForeground, parameters: nil)
        
        checkLegal()
    }
    
    func checkLegal() {
        if let lastViewedLegal = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.kLastAckedLegal) as? NSDate {
            let weekTimeInterval: NSTimeInterval = 24 * 60 * 60 * 30
            if lastViewedLegal.timeIntervalSince1970 + weekTimeInterval < NSDate().timeIntervalSince1970 {
                // show alert controller
                showLegalDisclaimerAlert()
            }
        } else {
            showLegalDisclaimerAlert()
        }
    }
    
    func showLegalDisclaimerAlert() {
        guard let topViewController = AppDelegate.topMostViewController() else { return }

        let viewAction = UIAlertAction(title: "View", style: .Default) { (action: UIAlertAction) in
            guard let topViewController = topViewController as? MainTabBarController else { return }
            let tabBar = topViewController.tabBar
            if let items = tabBar.items {
                topViewController.selectedIndex = items.count - 1
                guard let navigationController = topViewController.selectedViewController as? UINavigationController else { return }
                guard let settingsViewController = navigationController.viewControllers.first as? SettingsViewController else { return }
                settingsViewController.showLegal()
            }
        }
        
        let alertController = UIAlertController(title: "Legal Disclaimer", message: "In order to use Forex Bot, please view the Legal Disclaimer.", preferredStyle: .Alert)
        alertController.addAction(viewAction)
        
        topViewController.presentViewController(alertController, animated: true, completion: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kAppDidBecomeActive, parameters: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kAppTerminated, parameters: nil)
    }
    
    class func registerForPushNotifications(application: UIApplication) {
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
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kRegisteredForPushNotification, parameters: nil)
        
        let baseUrl = NetworkManager.sharedInstance.baseUrl
        let url = "\(baseUrl)/register_token/\(tokenString).json"

        let request = Alamofire.request(.POST, url, parameters: nil, encoding: .JSON)
        request.responseJSON { (response) in
            print(response)
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kFailedRegisterForPushNotification, parameters: nil)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kReceivedPushNotification, parameters: nil)
    }
    
    class func topMostViewController() -> UIViewController? {
        var presentedViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        while let viewController = presentedViewController?.presentedViewController {
            presentedViewController = viewController
        }
        
        if presentedViewController == nil {
        }
        return presentedViewController
    }
}

