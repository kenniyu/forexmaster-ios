//
//  ProfileEmployersTableViewCell.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/17/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class ProfileEmployersTableViewCell: UITableViewCell {
    @IBOutlet weak var employerTitleLabel: UILabel!
    @IBOutlet weak var employerDetailLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: ProfileEmployersTableViewCell.self))
    static let kClassName = "ProfileEmployersTableViewCell"
    static let kReuseIdentifier = "ProfileEmployersTableViewCell"
    static let kCellHeight: CGFloat = 90
    
    public class var nib: UINib {
        get {
            return ProfileEmployersTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return ProfileEmployersTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup(viewModel: ProfileDetailsViewModel) {
        setupStyles()
        loadDataIntoViews(viewModel)
    }
    
    public func loadDataIntoViews(viewModel: ProfileDetailsViewModel) {
        employerTitleLabel.text = "Employer"
        
        if let employer = viewModel.employer {
            employerDetailLabel.text = String(employer)
        } else {
            employerDetailLabel.text = "Unemployed"
        }
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        containerView.cornerRadius = 3
        containerView.clipsToBounds = true
        
        employerDetailLabel.font = Styles.Fonts.avenirRegularFontWithSize(24)
        employerTitleLabel.font = Styles.Fonts.avenirRegularFontWithSize(16)
        
        employerDetailLabel.textColor = Styles.Colors.Black
        employerTitleLabel.textColor = Styles.Colors.Gray
    }
}