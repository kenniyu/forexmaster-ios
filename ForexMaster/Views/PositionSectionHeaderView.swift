//
//  PositionSectionHeaderView.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public enum PairSortDirection: Int {
    case None
    case Up
    case Down
}


public protocol PositionSectionHeaderViewDelegate {
    func didSort(sortDirection: PairSortDirection)
}

public class PositionSectionHeaderView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var pairButton: UIButton!
    @IBOutlet weak var profitLossLabel: UILabel!
    @IBOutlet weak var costBasisLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var verticalBorderView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    public static let kHeight: CGFloat = 32
    
    public var sortDirection: PairSortDirection = .None
    
    public var positionTableViewCellDelegate: PositionTableViewCellDelegate?
    public var positionSectionHeaderViewDelegate: PositionSectionHeaderViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "PositionSectionHeaderView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        view.backgroundColor = UIColor.whiteColor()
        
        // Adjust bounds
        view.frame = self.bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Add subview
        addSubview(self.view)
        
        layoutIfNeeded()
    }
    
    public func stringForSortDirection() -> String {
        switch sortDirection {
        case .Up:
            return "\u{25B2}"
        case .Down:
            return "\u{25BC}"
        default:
            return ""
        }
    }
    
    public func loadDataIntoViews() {
        let sortDirectionStr = stringForSortDirection()
        let pairButtonTitle = "Pair \(sortDirectionStr)"
        pairButton.titleLabel?.text = pairButtonTitle
        pairButton.setTitle(pairButtonTitle, forState: .Normal)
        profitLossLabel.text = "P/L Open"
        costBasisLabel.text = "Cost Basis"
        markLabel.text = "Mark"
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        scrollView.contentSize = CGSizeMake(3 * 100, PositionSectionHeaderView.kHeight)
    }
    
    public func setup(sortDirection: PairSortDirection = .None) {
        self.sortDirection = sortDirection
        setupStyles()
        loadDataIntoViews()
    }
    
    public func setupStyles() {
        pairButton.titleLabel?.font = Styles.Fonts.avenirRegularFontWithSize(14)
        pairButton.titleLabel?.textColor = Styles.Colors.Black
        pairButton.tintColor = Styles.Colors.Black
        
        profitLossLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        profitLossLabel.textColor = Styles.Colors.Black
        costBasisLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        costBasisLabel.textColor = Styles.Colors.Black
        markLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        markLabel.textColor = Styles.Colors.Black
        
        bottomBorderView.backgroundColor = Styles.Colors.Black.colorWithAlphaComponent(0.1)
        verticalBorderView.backgroundColor = Styles.Colors.Black.colorWithAlphaComponent(0.1)
    }
    
    @IBAction func tappedPairButton(sender: UIButton) {
        switch sortDirection {
        case .None:
            sortDirection = .Up
        case .Up:
            sortDirection = .Down
        case .Down:
            sortDirection = .None
        }
        positionSectionHeaderViewDelegate?.didSort(sortDirection)
    }
}

extension PositionSectionHeaderView: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let horizontalOffset = scrollView.contentOffset.x
        positionTableViewCellDelegate?.didScrollScrollView(self, scrollViewOffset: horizontalOffset)
    }
}
