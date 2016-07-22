//
//  PositionDataCollectionViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/21/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class PositionDataCollectionViewCellModel {
    var data: AnyObject?
    var columnType: PositionDataColumn = PositionDataColumn.Count
    
    public init(data: AnyObject?, columnType: PositionDataColumn) {
        self.data = data
        self.columnType = columnType
    }
}

public class PositionDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: PositionDataCollectionViewCell.self))
    static let kClassName = "PositionDataCollectionViewCell"
    static let kReuseIdentifier = "PositionDataCollectionViewCell"
    
    public class var nib: UINib {
        get {
            return PositionDataCollectionViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return PositionDataCollectionViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupStyles()
    }

    public func setupStyles() {
        dataLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        dataLabel.textColor = Styles.Colors.Gray
    }
    
    public func setup(viewModel: PositionDataCollectionViewCellModel) {
        loadDataIntoViews(viewModel)
    }
    
    public func loadDataIntoViews(viewModel: PositionDataCollectionViewCellModel) {
        dataLabel.textColor = Styles.Colors.Gray
        switch viewModel.columnType {
        case .PnL:
            guard let profitLoss = viewModel.data as? String else { return }
            guard let profitLossDouble = Double(profitLoss) else { return }
            dataLabel.text = CurrencyUtils.toCurrencyString(profitLossDouble, maximumFractionDigits: 2)
            if profitLossDouble > 0 {
                dataLabel.textColor = Styles.Colors.Green
            } else if profitLossDouble < 0 {
                dataLabel.textColor = Styles.Colors.Red
            }
        case .CostBasis:
            guard let costBasis = viewModel.data as? String else { return }
            dataLabel.text = costBasis
        case .Mark:
            if let quote = viewModel.data as? Quote {
                let quoteDirection = quote.direction
                switch quoteDirection {
                case 1:
                    dataLabel.textColor = Styles.Colors.Green
                case -1:
                    dataLabel.textColor = Styles.Colors.Red
                default:
                    dataLabel.textColor = Styles.Colors.Gray
                }
                dataLabel.text = String(quote.quote)
            } else {
                dataLabel.text = "-"
            }
        default:
            break
        }
    }
}
