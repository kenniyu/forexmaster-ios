//
//  InitialViewController.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/16/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class InitialViewController: BaseViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var signUpLogInContainerView: UIView!
    
    @IBOutlet weak var topConstraintView: UIView!
    @IBOutlet weak var bottomConstraintView: UIView!
    
    public override class var kNibName: String {
        get {
            return "InitialViewController"
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupStyles() {
        super.setupStyles()
        
        logoLabel.font = Styles.Fonts.avenirRegularFontWithSize(48)
        signUpButton.applyStyle(.Primary)
        logInButton.applyStyle(.Secondary)
    }
    
    @IBAction func tappedLogIn(sender: UIButton) {
//        let homeViewController = HomeViewController()
//        let navigationController = UINavigationController(rootViewController: homeViewController)
        AppDelegate.launchAppControllers()
//        presentViewController(navigationController, animated: true, completion: nil)
    }
}