//
//  HistoryTableViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class HistoryTableViewCellModel {
    var trade: Trade
    
    public init(trade: Trade) {
        self.trade = trade
    }
}

public class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tradeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: HistoryTableViewCell.self))
    static let kClassName = "HistoryTableViewCell"
    static let kReuseIdentifier = "HistoryTableViewCell"
    static let kCellHeight: CGFloat = 70
    
    public class var nib: UINib {
        get {
            return HistoryTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return HistoryTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup(viewModel: HistoryTableViewCellModel) {
        setupStyles()
        loadDataIntoViews(viewModel)
    }
    
    public func getTradeDescription(viewModel: HistoryTableViewCellModel) -> String {
        let trade = viewModel.trade
        let size = trade.size
        let sizeStr = size > 0 ? "+\(size)" : "\(size)"
        let status = getTradeStatus(viewModel)
        
        let text = "\(sizeStr) \(trade.pair) @\(trade.mark) (\(status))"
        return text
    }
    
    public func getTradeStatus(viewModel: HistoryTableViewCellModel) -> String {
        let trade = viewModel.trade
        let status = trade.status
        
        switch status {
        case 0:
            return "Open"
        case 1:
            return "Adjust"
        case 2:
            return "Close"
        default:
            return ""
        }
    }
    
    public func getTradeDate(viewModel: HistoryTableViewCellModel) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "EEE, MMMM dd 'at' hh:mm:ss a zzz"
        let dateString = dateFormatter.stringFromDate(viewModel.trade.date)
        return dateString
    }
    
    public func loadDataIntoViews(viewModel: HistoryTableViewCellModel) {
        tradeLabel.text = getTradeDescription(viewModel)
        dateLabel.text = getTradeDate(viewModel)
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        tradeLabel.font = Styles.Fonts.avenirRegularFontWithSize(16)
        tradeLabel.textColor = Styles.Colors.Black
        
        dateLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        dateLabel.textColor = Styles.Colors.Gray
    }
}
