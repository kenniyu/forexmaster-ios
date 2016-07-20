//
//  UIView+.swift
//
//  Created by Ken Yu on 10/3/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    public func addCloseButton() {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(UIViewController.closeVc))
        let leftBarButtonItems = [closeBtn]
        navigationItem.leftBarButtonItems = leftBarButtonItems
    }
    
    public func createDoneButton() -> UIBarButtonItem {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(UIViewController.done))
        return closeBtn
    }
    
    public func createAddButton() -> UIBarButtonItem {
        let closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(UIViewController.add))
        return closeBtn
    }
    
    public func addRightBarButtons(buttons: [UIBarButtonItem]) {
        let rightBarButtonItems = buttons
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    public func closeVc() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func add() {
        // TO BE OVERRIDDEN
    }
}