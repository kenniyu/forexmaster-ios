//
//  SettingsTableViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/26/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class SettingsTableViewCellModel {
    var title: String
    var switchValue: Bool?
    public init(title: String, switchValue: Bool?) {
        self.title = title
        self.switchValue = switchValue
    }
}

public class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: SettingsTableViewCell.self))
    static let kClassName = "SettingsTableViewCell"
    static let kReuseIdentifier = "SettingsTableViewCell"
    static let kCellHeight: CGFloat = 50
    
    public class var nib: UINib {
        get {
            return SettingsTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return SettingsTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup(viewModel: SettingsTableViewCellModel) {
        setupStyles()
        loadDataIntoViews(viewModel)
    }

    public func loadDataIntoViews(viewModel: SettingsTableViewCellModel) {
        titleLabel.text = viewModel.title
        
        if let switchValue = viewModel.switchValue {
            switchControl.hidden = false
            switchControl.on = switchValue
            selectionStyle = .None
        } else {
            selectionStyle = .Default
            switchControl.hidden = true
            accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
    }
    
    public func setupStyles() {
        backgroundColor = Styles.Colors.LighterGray
        contentView.backgroundColor = Styles.Colors.LighterGray
        containerView.backgroundColor = Styles.Colors.LighterGray
        
        switchControl.onTintColor = Styles.Colors.Green
        titleLabel.font = Styles.Fonts.avenirRegularFontWithSize(16)
        titleLabel.textColor = Styles.Colors.Black
    }
    
    @IBAction func toggledSwitch(sender: UISwitch) {
        let isOn = sender.on
        if isOn {
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            UIApplication.sharedApplication().unregisterForRemoteNotifications()
        }
    }
}
