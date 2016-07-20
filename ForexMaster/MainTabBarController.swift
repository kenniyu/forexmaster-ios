//
//  MainTabBarController.swift
//

import UIKit

public class MainTabBarController: UITabBarController {
    
    public static let kTabBarControllerFont = Styles.Fonts.avenirRegularFontWithSize(12)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.translucent = false
        self.tabBar.tintColor = Styles.Colors.Green
        self.tabBar.barTintColor = Styles.Colors.White
        
        let appearance = UITabBarItem.appearance()
        if let font: UIFont = MainTabBarController.kTabBarControllerFont {
            let selectedAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: Styles.Colors.Green]
            let defaultAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: Styles.Colors.Gray]
            appearance.setTitleTextAttributes(defaultAttributes, forState: .Normal)
            appearance.setTitleTextAttributes(selectedAttributes, forState: .Selected)
        } else {
            print("Font unavailable")
        }
    }
    
    /**
     Disables interactions for all UITabBarItems.
     */
    func disableAllTabBarItems() {
        if let items = tabBar.items {
            items.forEach{ item in item.enabled = false }
        }
    }
}
