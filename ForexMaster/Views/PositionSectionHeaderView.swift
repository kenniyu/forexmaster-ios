//
//  PositionSectionHeaderView.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class PositionSectionHeaderView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var pairLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var costBasisLabel: UILabel!
    @IBOutlet weak var verticalBorderView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    
    public static let kHeight: CGFloat = 32
    
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
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
    }
    
    public func setup() {
        setupStyles()
    }
    
    public func setupStyles() {
        pairLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        markLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        costBasisLabel.font = Styles.Fonts.avenirRegularFontWithSize(14)
        
        pairLabel.textColor = Styles.Colors.Black
        markLabel.textColor = Styles.Colors.Black
        costBasisLabel.textColor = Styles.Colors.Black
        
        bottomBorderView.backgroundColor = Styles.Colors.Black.colorWithAlphaComponent(0.1)
        verticalBorderView.backgroundColor = Styles.Colors.Black.colorWithAlphaComponent(0.1)
    }
}

