//
//  MessageTableViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/25/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class MessageTableViewCellModel {
    var message: Message
    
    public init(message: Message) {
        self.message = message
    }
}

public class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    public var dataModel: MessageTableViewCellModel?
    
    public static let kVerticalSpacing: CGFloat = 10
    
    public class var kReuseIdentifier: String {
        get {
            return "MessageTableViewCell"
        }
    }
    
    public class var kClassName: String {
        get {
            return "MessageTableViewCell"
        }
    }
    
    public class var kNib: UINib {
        get {
            return UINib(nibName: kClassName, bundle: NSBundle(forClass: MessageTableViewCell.self))
        }
    }
    
    public class var nib: UINib {
        get {
            return MessageTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return MessageTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    public func setup(dataModel: MessageTableViewCellModel) {
        self.dataModel = dataModel
        setupStyles(dataModel)
        
        loadDataIntoViews(dataModel)
    }
    
    public func setupStyles(dataModel: MessageTableViewCellModel) {
        // Cell styles
        contentView.backgroundColor = UIColor.clearColor()
        containerView.backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        // Element styles
        titleLabel.numberOfLines = 0
        titleLabel.font = getTitleLabelFontStyle()
        titleLabel.textColor = Styles.Colors.Black
        
        detailLabel.numberOfLines = 1
        detailLabel.font = getDetailLabelFontStyle()
        detailLabel.textColor = Styles.Colors.Gray
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // set cell container frame
        // containerView.frame = UIEdgeInsetsInsetRect(bounds, feedModel.style.cellContainerMargin)
        
        containerView.frame = bounds
        containerView.clipsToBounds = true
        
        setSubviewFrames()
    }
    
    public func setSubviewFrames() {
        guard let dataModel = dataModel else { return }
        
        let contentWidth = getContentWidth(containerView.width)
        
        titleLabel.top = getPaddingTop()
        titleLabel.left = getPaddingLeft()
        titleLabel.width = getContentWidth(containerView.width)
        titleLabel.height = getLabelHeight(contentWidth, text: dataModel.message.body, font: getTitleLabelFontStyle())
        
        let tradeDate = MessageTableViewCell.getTradeDate(dataModel)
        detailLabel.top = titleLabel.bottom + MessageTableViewCell.kVerticalSpacing
        detailLabel.left = getPaddingLeft()
        detailLabel.width = getContentWidth(containerView.width)
        detailLabel.height = getLabelHeight(contentWidth, text: tradeDate, font: getDetailLabelFontStyle())
    }
    
    public func loadDataIntoViews(viewModel: MessageTableViewCellModel?) {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.message.body
        
        let tradeDate = MessageTableViewCell.getTradeDate(viewModel)
        detailLabel.text = tradeDate
    }
    
    public class func getTradeDate(viewModel: MessageTableViewCellModel) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "EEE, MMMM dd 'at' hh:mm:ss a zzz"
        let dateString = dateFormatter.stringFromDate(viewModel.message.date)
        return dateString
    }
    
    public class func size(boundingWidth: CGFloat, viewModel: MessageTableViewCellModel, constrainedWidthAdjustment: CGFloat = 0) -> CGSize {
        var cellHeight: CGFloat = 0
        
        // Padding top
        cellHeight += getPaddingTop()
        
        // Title Label
        let constrainedWidth = getContentWidth(boundingWidth)
        let titleLabelHeight = getLabelHeight(constrainedWidth, text: viewModel.message.body, font: getTitleLabelFontStyle())
        cellHeight += titleLabelHeight

        cellHeight += MessageTableViewCell.kVerticalSpacing
        
        let tradeDate = getTradeDate(viewModel)
        let detailLabelHeight = getLabelHeight(constrainedWidth, text: tradeDate, font: getDetailLabelFontStyle())
        cellHeight += detailLabelHeight
        
        // Padding bottom
        cellHeight += getPaddingBottom()
        return CGSizeMake(boundingWidth, cellHeight)
    }
    
    // MARK Instance-to-Class methods
    public func getLabelHeight(boundingWidth: CGFloat, text: String, font: UIFont, attributedText: NSMutableAttributedString? = nil) -> CGFloat {
        return self.dynamicType.getLabelHeight(boundingWidth, text: text, font: font, attributedText: attributedText)
    }
    
    public func getTitleLabelFontStyle() -> UIFont {
        return self.dynamicType.getTitleLabelFontStyle()
    }
    
    public func getDetailLabelFontStyle() -> UIFont {
        return self.dynamicType.getDetailLabelFontStyle()
    }
    
    public func getPaddingTop() -> CGFloat {
        return self.dynamicType.getPaddingTop()
    }
    
    public func getPaddingBottom() -> CGFloat {
        return self.dynamicType.getPaddingBottom()
    }
    
    public func getPaddingLeft() -> CGFloat {
        return self.dynamicType.getPaddingLeft()
    }
    
    public func getPaddingRight() -> CGFloat {
        return self.dynamicType.getPaddingLeft()
    }
    
    public func getTitleDetailSpacing() -> CGFloat {
        return self.dynamicType.getTitleDetailSpacing()
    }
    
    public func getContentWidth(containerWidth: CGFloat) -> CGFloat {
        return self.dynamicType.getContentWidth(containerWidth)
    }
    
    public func getAttributedTitleString(text: String?) -> NSMutableAttributedString? {
        return self.dynamicType.getAttributedTitleString(text)
    }
    
    public func getAttributedDetailString(text: String?) -> NSMutableAttributedString? {
        return self.dynamicType.getAttributedDetailString(text)
    }
    
    public func getLineHeight() -> CGFloat {
        return self.dynamicType.getLineHeight()
    }
    
    // MARK Class Methods
    public class func getPaddingTop() -> CGFloat {
        return 20
    }
    
    public class func getPaddingBottom() -> CGFloat {
        return 20
    }
    
    public class func getPaddingLeft() -> CGFloat {
        return 20
    }
    
    public class func getPaddingRight() -> CGFloat {
        return 20
    }
    
    public class func getContentWidth(containerWidth: CGFloat) -> CGFloat {
        return containerWidth - getPaddingLeft() - getPaddingRight()
    }
    
    public class func getTitleDetailSpacing() -> CGFloat {
        return Styles.Dimensions.kItemSpacingDim2
    }
    
    public class func getTitleLabelFontStyle() -> UIFont {
        return Styles.Fonts.avenirRegularFontWithSize(16)
    }
    
    public class func getDetailLabelFontStyle() -> UIFont {
        return Styles.Fonts.avenirRegularFontWithSize(14)
    }
    
    public class func getTitleLabelNumberOfLines() -> Int {
        return 0
    }
    
    public class func getDetailLabelNumberOfLines() -> Int {
        return 0
    }
    
    public class func getAttributedTitleString(text: String?) -> NSMutableAttributedString? {
        // TODO: To be implemented by subclass if needed
        return nil
    }
    
    public class func getAttributedDetailString(text: String?) -> NSMutableAttributedString? {
        // TODO: To be implemented by subclass if needed
        return nil
    }
    
    public class func getLineHeight() -> CGFloat {
        return 0
    }
    
    public class func getLabelHeight(boundingWidth: CGFloat, text: String, font: UIFont, attributedText: NSMutableAttributedString? = nil) -> CGFloat {
        let textHeight = TextUtils.textHeight(text, font: font, boundingWidth: boundingWidth, numberOfLines: getTitleLabelNumberOfLines(), attributedText: attributedText)
        return textHeight
    }
}

