//
//  SettingsViewController.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/26/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import Firebase

public enum SettingsSections: Int {
    case Basic = 0
    case User
    case Count
}

public enum BasicSectionRows: Int {
    case Legal = 0
    case Count
}

public enum UserSectionRows: Int {
    case PushNotifications = 0
    case Count
}

public class SettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public var cellModels: [[SettingsTableViewCellModel]] = []
    
    public override var navBarTitle: String {
        get {
            return "Settings"
        }
    }
    
    public func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    public override func setupStyles() {
        super.setupStyles()
        setupTableView()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kSettingsScreenPageView, parameters: [
            "env": EnvironmentManager.sharedInstance.configuration
        ])
        updateCellModels()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    public func registerCells() {
        tableView.registerNib(SettingsTableViewCell.kNib, forCellReuseIdentifier: SettingsTableViewCell.kReuseIdentifier)
        tableView.registerClass(BaseTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: BaseTableViewHeaderFooterView.kReuseIdentifier)
    }
    
    public func updateCellModels() {
        cellModels = []
        
        var basicSectionRows: [SettingsTableViewCellModel] = []
        let legalRow = SettingsTableViewCellModel(title: "Legal Disclaimer", switchValue: nil)
        basicSectionRows.append(legalRow)
        
        var userSectionRows: [SettingsTableViewCellModel] = []
        
        let allowNotifications = UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
        let notificationsRow = SettingsTableViewCellModel(title: "Trade Notifications", switchValue: allowNotifications)
        userSectionRows.append(notificationsRow)
        
        cellModels = [
            basicSectionRows,
            userSectionRows
        ]
        
        // filter
        tableView.reloadData()
    }
    
    public func showLegal() {
        let legalViewController = LegalViewController(url: LegalViewController.kUrl)
        navigationController?.pushViewController(legalViewController, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellModels.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels[section].count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SettingsTableViewCell.kCellHeight
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(SettingsTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? SettingsTableViewCell {
            let cellModel = cellModels[indexPath.section][indexPath.row]
            cell.setup(cellModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BaseTableViewHeaderFooterView.kReuseIdentifier) as? BaseTableViewHeaderFooterView {
            switch section {
            case 0:
                headerView.setup("About")
            case 1:
                headerView.setup("Preferences")
            default:
                break
            }
            return headerView
        }
        return UIView()
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BaseTableViewHeaderFooterView.kReuseIdentifier) as? BaseTableViewHeaderFooterView {
            headerView.setup("")
            return headerView
        }
        return UIView()
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return BaseTableViewHeaderFooterView.kHeaderHeight
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == SettingsSections.Count.rawValue - 1 {
            return 0
        }
        return BaseTableViewHeaderFooterView.kFooterHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case SettingsSections.Basic.rawValue:
            switch indexPath.row {
            case BasicSectionRows.Legal.rawValue:
                showLegal()
            default:
                break
            }
        default:
            break
        }
    }
}