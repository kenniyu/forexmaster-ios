//
//  HomeViewController.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/16/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class HomeViewController: BaseViewController {
    public override class var kNibName: String {
        get {
            return "HomeViewController"
        }
    }
    
    public override var navBarTitle: String {
        get {
            return "Home"
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override func setup() {
        super.setup()
    }
}