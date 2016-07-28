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
    public static let kMarginTop: CGFloat = 20
    public static let kMarginBottom: CGFloat = 20
    public static let kMarginRight: CGFloat = 20
    public static let kMarginLeft: CGFloat = 50
    
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
    
    public func setup(performance: Performance) {
        print(performance)
        loadDataIntoViews(performance)
    }
    
    public func loadDataIntoViews(performance: Performance) {
        // Horizontal lines
        let numLines: CGFloat = 6
        
        // First, remove lines
        removeSubviews()
        
        // Add lines
        lines = []
        labels = []
        
        let maxPct: Double = 100
        let tickSize = maxPct/(Double(numLines - 1))
        
        let lineWidth = width - PerformanceChart.kMarginLeft - PerformanceChart.kMarginRight
        for index in 0 ..< Int(numLines) {
            let ySlope = (PerformanceChart.kMarginTop - (height - PerformanceChart.kMarginBottom))/100
            let yOffset = height - PerformanceChart.kMarginBottom
            let yPoint = ySlope * CGFloat(index * 20) + yOffset
            
            let line = HorizontalLineView(frame: CGRectMake(PerformanceChart.kMarginLeft, yPoint, lineWidth, 1))
            line.backgroundColor = Styles.Colors.LightGray
            lines.append(line)
            
            let label = UILabel(frame: CGRectMake(0, yPoint, PerformanceChart.kMarginLeft - 10, 20))
            label.center.y = yPoint
            label.text = "\(index * 20)%"
            label.textAlignment = .Right
            label.font = Styles.Fonts.avenirRegularFontWithSize(12)
            label.textColor = Styles.Colors.Gray
            
            view.addSubview(line)
            view.addSubview(label)
        }
        
        // Plot data
        plotData(performance)
    }
    
    public func plotData(performance: Performance) {
//        print(performance.trades)
//        print(performance.date.timeIntervalSince1970)
        var totalProfit: Double = 0
        var minDate: NSTimeInterval = NSDate().timeIntervalSince1970
        var maxDate: NSTimeInterval = 0
        var maxProfit: Double = -1
        var minProfit: Double = 0
        
        var cumulativeProfits: [Double] = []
        
        for trade in performance.closedTrades {
            let date = trade.date.timeIntervalSince1970
            totalProfit += trade.profit
            if minDate > date {
                minDate = date
            }
            if maxDate < date {
                maxDate = date
            }
            
            if totalProfit > maxProfit {
                maxProfit = totalProfit
            }
            
            cumulativeProfits.append(totalProfit)
        }
        
        let initialAccountBalance: Double = performance.initialBalance
        
        var points: [CGPoint] = []
        
        for (index, trade) in performance.closedTrades.enumerate() {
            let currentProfit = cumulativeProfits[index]
            let profitPct = currentProfit/initialAccountBalance * 100
            
            let xSlope = CGFloat(width - PerformanceChart.kMarginRight - PerformanceChart.kMarginLeft - PerformanceChart.kMarginLeft)/CGFloat(maxDate - minDate)
            let xOffset = PerformanceChart.kMarginLeft - xSlope * CGFloat(minDate)
            let xPoint = xSlope * CGFloat(trade.date.timeIntervalSince1970) + xOffset
            
            let ySlope = (PerformanceChart.kMarginTop - (height - PerformanceChart.kMarginBottom))/100
            let yOffset = height - PerformanceChart.kMarginBottom
            let yPoint = ySlope * CGFloat(profitPct) + yOffset
            
            let view = UIView(frame: CGRectMake(xPoint, yPoint, 5, 5))
            let centerPoint = CGPointMake(xPoint, yPoint)
            view.center = centerPoint
            points.append(centerPoint)
            view.backgroundColor = Styles.Colors.Green
            view.cornerRadius = 3
            addSubview(view)
        }
        
        let context = UIGraphicsGetCurrentContext()
        
        var previousPoint = points.first
        for (index, point) in points.enumerate() {
            if index == 0 {
            } else {
                // draw line between previous point and point
                if let previousPoint = previousPoint {
                    CGContextMoveToPoint(context, previousPoint.x, previousPoint.y)
                }
                CGContextAddLineToPoint(context, point.x, point.y)
            }
            previousPoint = point
        }
        
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextStrokePath(context)
        UIGraphicsEndImageContext()

//        y = mx + b
        
//        print(minDate)
//        print(maxDate)
//        let minDate = performance.trades.map
        
        
    }
}