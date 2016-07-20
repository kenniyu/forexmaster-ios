//
//  BaseViewController.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/16/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class BaseViewController: UIViewController {
    public class var kNibName: String {
        get {
            return "BaseViewController"
        }
    }
    
    public var navBarTitle: String {
        get {
            return "Base"
        }
    }
    
    // Inits
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: self.dynamicType.kNibName, bundle: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupStyles()
    }
    
    public func topBarHeight() -> CGFloat {
        return statusBarHeight() + navBarHeight()
    }
    
    public func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return min(statusBarSize.width, statusBarSize.height)
    }
    
    public func navBarHeight() -> CGFloat {
        return navigationController?.navigationBar.height ?? 0
    }
    
    public func setup() {
        title = self.navBarTitle
    }
    
    public func setupStyles() {
        view.backgroundColor = Styles.Colors.LightGray
    }

}