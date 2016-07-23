//
//  PerformanceChart.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/22/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class HorizontalLineView: UIView {
//    public var lineWidth: CGFloat = 0
//    public var lineX: CGFloat = 0
//    public var lineY: CGFloat = 0
//    
//    public convenience init(lineX: CGFloat, lineY: CGFloat, lineWidth: CGFloat = 0) {
//        self.init(coder: CGRectMake(lineX, lineY, lineWidth, 1))
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

public class PerformanceChart: UIView {
    @IBOutlet weak var view: UIView!
    
    public var lines: [HorizontalLineView] = []
    public var labels: [UILabel] = []
    
    public static let kHeight: CGFloat = 240
    
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
        let nib = UINib(nibName: "PerformanceChart", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        view.backgroundColor = UIColor.clearColor()
        
        // Adjust bounds
        view.frame = self.bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Add subview
        addSubview(self.view)
        
        layoutIfNeeded()
    }
    
    public func removeSubviews() {
        for subview in view.subviews {
            if let subview = subview as? HorizontalLineView {
                subview.removeFromSuperview()
            }
        }
    }
    
    public func setup() {
        loadDataIntoViews()
    }
    
    public func loadDataIntoViews() {
        // Horizontal lines
        let numLines: CGFloat = 6
        let viewHeight = PerformanceChart.kHeight
        let marginTop: CGFloat = 20
        let marginBottom: CGFloat = 20
        let marginRight: CGFloat = 20
        let marginLeft: CGFloat = 50
        
        // First, remove lines
        removeSubviews()
        
        // Add lines
        lines = []
        labels = []
        
        let maxPct: Double = 100
        let tickSize = maxPct/(Double(numLines - 1))
        
        let lineWidth = width - marginLeft - marginRight
        for index in 0 ..< Int(numLines) {
            let lineY = CGFloat(index) * (viewHeight - marginBottom - marginTop)/numLines + marginTop
            let line = HorizontalLineView(frame: CGRectMake(marginLeft, lineY, lineWidth, 1))
            line.backgroundColor = Styles.Colors.LightGray
            lines.append(line)
            
            let label = UILabel(frame: CGRectMake(0, lineY, marginLeft - 10, 20))
            label.center.y = lineY
            label.text = "\(Int(maxPct) - (index * Int(tickSize)))%"
            label.textAlignment = .Right
            label.font = Styles.Fonts.avenirRegularFontWithSize(12)
            label.textColor = Styles.Colors.Gray
            
            view.addSubview(line)
            view.addSubview(label)
        }
    }
}