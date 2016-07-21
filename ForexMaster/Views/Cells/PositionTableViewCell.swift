//
//  PositionTableViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class PositionTableViewCellModel {
    var position: Position
    
    public init(position: Position) {
        self.position = position
    }
}

public class PositionTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalBorderView: UIView!
    @IBOutlet weak var pairLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var costBasisLabel: UILabel!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: PositionTableViewCell.self))
    static let kClassName = "PositionTableViewCell"
    static let kReuseIdentifier = "PositionTableViewCell"
    static let kCellHeight: CGFloat = 65
    
    public class var nib: UINib {
        get {
            return PositionTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return PositionTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup(viewModel: PositionTableViewCellModel) {
        setupStyles()
        loadDataIntoViews(viewModel)
    }
    
    public func loadDataIntoViews(viewModel: PositionTableViewCellModel) {
        pairLabel.text = viewModel.position.pair
        let size = viewModel.position.size
        if size > 0 {
            sizeLabel.textColor = Styles.Colors.Green
            sizeLabel.text = "+\(viewModel.position.size)"
        } else {
            sizeLabel.textColor = Styles.Colors.Red
            sizeLabel.text = "\(viewModel.position.size)"
        }
        costBasisLabel.text = String(viewModel.position.costBasis)
        
        if let quote = viewModel.position.quote {
            quoteLabel.text = quote
        }
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        pairLabel.font = Styles.Fonts.avenirDemiBoldFontWithSize(16)
        pairLabel.textColor = Styles.Colors.Black
        
        sizeLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        
        quoteLabel.font = Styles.Fonts.avenirRegularFontWithSize(16)
        quoteLabel.textColor = Styles.Colors.Gray
        
        costBasisLabel.font = Styles.Fonts.avenirRegularFontWithSize(16)
        costBasisLabel.textColor = Styles.Colors.Gray
        
        verticalBorderView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
    }
}
