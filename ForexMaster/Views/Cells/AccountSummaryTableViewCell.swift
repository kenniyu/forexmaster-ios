//
//  AccountSummaryTableViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/23/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class AccountSummaryTableViewCellModel {
    var inceptionDate: NSDate
    var initialBalance: Double
    var settledProfits: Double
    var returnPct: Double
    
    public init(inceptionDate: NSDate, initialBalance: Double, settledProfits: Double, returnPct: Double) {
        self.inceptionDate = inceptionDate
        self.initialBalance = initialBalance
        self.settledProfits = settledProfits
        self.returnPct = returnPct
    }
}

public class AccountSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settledProfitsTextLabel: UILabel!
    @IBOutlet weak var inceptionDateTextLabel: UILabel!
    @IBOutlet weak var initialBalanceTextLabel: UILabel!
    @IBOutlet weak var returnTextLabel: UILabel!
    @IBOutlet weak var settledProfitsLabel: UILabel!
    @IBOutlet weak var inceptionDateLabel: UILabel!
    @IBOutlet weak var initialBalanceLabel: UILabel!
    @IBOutlet weak var returnLabel: UILabel!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: AccountSummaryTableViewCell.self))
    static let kClassName = "AccountSummaryTableViewCell"
    static let kReuseIdentifier = "AccountSummaryTableViewCell"
    static let kCellHeight: CGFloat = 180
    
    public class var nib: UINib {
        get {
            return AccountSummaryTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return AccountSummaryTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup(viewModel: AccountSummaryTableViewCellModel) {
        setupStyles()
        loadDataIntoViews(viewModel)
    }
    
    public func getInceptionDate(viewModel: AccountSummaryTableViewCellModel) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.stringFromDate(viewModel.inceptionDate)
        return dateString
    }
    
    public func loadDataIntoViews(viewModel: AccountSummaryTableViewCellModel) {
        inceptionDateLabel.text = getInceptionDate(viewModel)
        initialBalanceLabel.text = CurrencyUtils.toCurrencyString(viewModel.initialBalance, maximumFractionDigits: 2)
        settledProfitsLabel.text = CurrencyUtils.toCurrencyString(viewModel.settledProfits, maximumFractionDigits: 2)
        returnLabel.text = "\(viewModel.returnPct)%"
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        inceptionDateLabel.textColor = Styles.Colors.Black
        initialBalanceLabel.textColor = Styles.Colors.Green
        settledProfitsLabel.textColor = Styles.Colors.Green
        returnLabel.textColor = Styles.Colors.Green
        
        inceptionDateTextLabel.textColor = Styles.Colors.Black
        initialBalanceTextLabel.textColor = Styles.Colors.Black
        settledProfitsTextLabel.textColor = Styles.Colors.Black
        returnTextLabel.textColor = Styles.Colors.Black
        
        let labelTextFont = Styles.Fonts.avenirRegularFontWithSize(15)
        let labelAmountFont = Styles.Fonts.avenirRegularFontWithSize(15)
        
        inceptionDateLabel.font = labelAmountFont
        initialBalanceLabel.font = labelAmountFont
        settledProfitsLabel.font = labelAmountFont
        returnLabel.font = labelAmountFont
        
        inceptionDateTextLabel.font = labelTextFont
        initialBalanceTextLabel.font = labelTextFont
        settledProfitsTextLabel.font = labelTextFont
        returnTextLabel.font = labelTextFont
    }
}
