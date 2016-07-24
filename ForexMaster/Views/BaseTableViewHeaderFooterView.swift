//
//  BaseTableViewHeaderFooterView.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/24/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

import Foundation

public
class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public class var kNib: UINib {
        get {
            return UINib(nibName: kClassName, bundle: NSBundle(forClass: BaseTableViewHeaderFooterView.self))
        }
    }
    
    public class var kSectionHeaderFont: UIFont? {
        get {
            return Styles.Fonts.avenirBookFontWithSize(16)
        }
    }
    
    public class var kReuseIdentifier: String {
        get {
            return "BaseTableViewHeaderFooterView"
        }
    }
    
    public class var kClassName: String {
        get {
            return "BaseTableViewHeaderFooterView"
        }
    }
    
    public class var kHeight: CGFloat {
        get {
            return 50
        }
    }
    
    public class var nib: UINib {
        get {
            return BaseTableViewHeaderFooterView.kNib
        }
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        let views = NSBundle.mainBundle().loadNibNamed(self.dynamicType.kClassName, owner: self, options: nil)
        self.view = views.first as! UIView
        
        // Add subview
        addSubview(self.view)
        
        // Adjust bounds
        self.view.frame = self.bounds
        
        layoutIfNeeded()
    }
    
    public func setTitle(text: String) {
        titleLabel.text = text
    }
    
    public func setup(title: String) {
        titleLabel.font = BaseTableViewHeaderFooterView.kSectionHeaderFont
        
        titleLabel.textColor = Styles.Colors.Black
        view.backgroundColor = Styles.Colors.LightGray.colorWithAlphaComponent(0.1)
        setTitle(title)
    }
}
