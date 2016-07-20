//
//  ProfileStatsTableViewCell.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/17/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class ProfileDetailsViewModel {
    var profileImage: UIImage? = nil
    var name: String
    var headline: String
    var height: Int
    var age: Int
    var salary: Double?
    var employer: String?
    var educations: [String]?
    
    public init(name: String, headline: String, profileImage: UIImage? = nil, height: Int, age: Int, salary: Double, employer: String, educations: [String]? = []) {
        self.name = name
        self.headline = headline
        self.profileImage = profileImage
        self.height = height
        self.age = age
        self.salary = salary
        self.employer = employer
        self.educations = educations
    }
}

public class ProfileStatsTableViewCell: UITableViewCell {
    @IBOutlet weak var ageNumberLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightNumberLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: ProfileStatsTableViewCell.self))
    static let kClassName = "ProfileStatsTableViewCell"
    static let kReuseIdentifier = "ProfileStatsTableViewCell"
    static let kCellHeight: CGFloat = 90
    
    public class var nib: UINib {
        get {
            return ProfileStatsTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return ProfileStatsTableViewCell.kClassName
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
        heightNumberLabel.text = String(viewModel.height)
        ageNumberLabel.text = String(viewModel.age)
        
        ageLabel.text = "Age"
        heightLabel.text = "Height (cm)"
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        dividerView.backgroundColor = Styles.Colors.Gray.colorWithAlphaComponent(0.25)
        
        containerView.cornerRadius = 3
        containerView.clipsToBounds = true
        
        ageNumberLabel.font = Styles.Fonts.avenirRegularFontWithSize(24)
        ageLabel.font = Styles.Fonts.avenirRegularFontWithSize(16)
        heightNumberLabel.font = Styles.Fonts.avenirRegularFontWithSize(24)
        heightLabel.font = Styles.Fonts.avenirRegularFontWithSize(16)
        
        ageNumberLabel.textColor = Styles.Colors.Black
        ageLabel.textColor = Styles.Colors.Gray
        heightNumberLabel.textColor = Styles.Colors.Black
        heightLabel.textColor = Styles.Colors.Gray
    }
}