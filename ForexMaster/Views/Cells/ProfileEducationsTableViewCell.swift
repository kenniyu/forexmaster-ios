//
//  ProfileEducationsTableViewCell.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/17/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class ProfileEducationsTableViewCell: UITableViewCell {
    @IBOutlet weak var educationTitleLabel: UILabel!
    @IBOutlet weak var educationDetailLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: ProfileEducationsTableViewCell.self))
    static let kClassName = "ProfileEducationsTableViewCell"
    static let kReuseIdentifier = "ProfileEducationsTableViewCell"
    static let kCellHeight: CGFloat = 90
    
    public class var nib: UINib {
        get {
            return ProfileEducationsTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return ProfileEducationsTableViewCell.kClassName
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
        educationTitleLabel.text = "Recent Education"
        
        if let educations = viewModel.educations, firstEdu = educations.first {
            educationDetailLabel.text = firstEdu
        }
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        containerView.cornerRadius = 3
        containerView.clipsToBounds = true
        
        educationDetailLabel.font = Styles.Fonts.avenirRegularFontWithSize(24)
        educationTitleLabel.font = Styles.Fonts.avenirRegularFontWithSize(16)
        
        educationDetailLabel.textColor = Styles.Colors.Black
        educationTitleLabel.textColor = Styles.Colors.Gray
    }
}