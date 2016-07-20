//
//  ProfileTableViewCell.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/16/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class ProfileTableViewCellModel {
    var profileImage: UIImage? = nil
    var name: String
    var headline: String
    
    public init(name: String, headline: String, profileImage: UIImage? = nil) {
        self.name = name
        self.headline = headline
        self.profileImage = profileImage
    }
}

public class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileHeadlineLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: ProfileTableViewCell.self))
    static let kClassName = "ProfileTableViewCell"
    static let kReuseIdentifier = "ProfileTableViewCell"
    static let kCellHeight: CGFloat = 100
    
    public class var nib: UINib {
        get {
            return ProfileTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return ProfileTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup(viewModel: ProfileTableViewCellModel) {
        setupStyles()
        loadDataIntoViews(viewModel)
    }
    
    public func loadDataIntoViews(viewModel: ProfileTableViewCellModel) {
        profileNameLabel.text = viewModel.name
        profileHeadlineLabel.text = viewModel.headline
        cellImageView.image = viewModel.profileImage
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        containerView.cornerRadius = 3
        cellImageView.cornerRadius = 2
        cellImageView.layer.masksToBounds = true
        
        profileNameLabel.font = Styles.Fonts.avenirDemiBoldFontWithSize(16)
        profileNameLabel.textColor = Styles.Colors.Black
        profileHeadlineLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        profileHeadlineLabel.textColor = Styles.Colors.Gray
    }
}
