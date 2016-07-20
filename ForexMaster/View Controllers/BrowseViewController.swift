//
//  BrowseViewController.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/16/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class BrowseViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    public var cellModels: [ProfileTableViewCellModel] = []
    
    public override class var kNibName: String {
        get {
            return "BrowseViewController"
        }
    }
    
    public override var navBarTitle: String {
        get {
            return "Browse"
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateCellModels()
        tableView.reloadData()
    }
    
    public override func setupStyles() {
        super.setupStyles()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = Styles.Colors.LightGray
    }
    
    public func updateCellModels() {
        cellModels = []
        
    }
    
    public override func setup() {
        super.setup()
        
        let filterBtn = UIBarButtonItem(image: UIImage(named: "filter"), style: .Plain, target: self, action: #selector(BrowseViewController.tappedFilter))
        addRightBarButtons([filterBtn])
        
        registerCells()
    }
    
    public func registerCells() {
        tableView.registerNib(ProfileTableViewCell.kNib, forCellReuseIdentifier: ProfileTableViewCell.kReuseIdentifier)
    }
    
    public func tappedFilter() {
        let filterViewController = FilterViewController()
        let navigationController = UINavigationController(rootViewController: filterViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(ProfileTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? ProfileTableViewCell {
            let viewModel = cellModels[indexPath.row]
            cell.setup(viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ProfileTableViewCell.kCellHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let viewModel = cellModels[indexPath.row]
        let profileViewModel = ProfileViewModel(name: viewModel.name, headline: viewModel.headline, image: viewModel.profileImage)
        let profileViewController = ProfileViewController(profileViewModel: profileViewModel)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}