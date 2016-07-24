//
//  PushNotificationViewController.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/24/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public protocol PushNotificationViewControllerDelegate {
    func didConfirmPushNotifications()
    func didRejectPushNotifications()
}

public class PushNotificationViewController: BaseViewController {
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    public var pushNotificationViewControllerDelegate: PushNotificationViewControllerDelegate?

    public class override var kNibName: String {
        get {
            return "PushNotificationViewController"
        }
    }
//    public static let kNibName = "PushNotificationViewController"
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: PushNotificationViewController.kNibName, bundle: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override func setupStyles() {
        super.setupStyles()
        
        modalView.cornerRadius = 5
        modalView.backgroundColor = UIColor.whiteColor()
        confirmButton.cornerRadius = 3
        confirmButton.clipsToBounds = true
        confirmButton.setBackgroundImage(UIImage().imageWithColor(Styles.Colors.Green), forState: .Normal)
        confirmButton.tintColor = UIColor.whiteColor()
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    @IBAction func tappedConfirmButton(sender: UIButton) {
        dismissViewControllerAnimated(true) { 
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.pushNotificationViewControllerDelegate?.didConfirmPushNotifications()
        }
    }
    
    @IBAction func tappedCancelButton(sender: UIButton) {
        dismissViewControllerAnimated(true) {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.pushNotificationViewControllerDelegate?.didRejectPushNotifications()
        }
    }
}