//
//  FilterViewController.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/16/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class FilterViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    public override var nibName: String {
        get {
            return "FilterViewController"
        }
    }
    
    public override var navBarTitle: String {
        get {
            return "Filters"
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    public override func setup() {
        super.setup()
        addCloseButton()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 0
    }
}