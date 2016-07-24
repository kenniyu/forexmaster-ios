//
//  PerformanceChartTableViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/22/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import Charts

public class PerformanceChartTableViewCellModel {
    var performance: Performance
    public init(performance: Performance) {
        self.performance = performance
    }
}

public enum PerformanceChartMode {
    case Return
    case Profits
}

public class PerformanceChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
    public var performanceChart: PerformanceChart? = nil
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: PerformanceChartTableViewCell.self))
    static let kClassName = "PerformanceChartTableViewCell"
    static let kReuseIdentifier = "PerformanceChartTableViewCell"
    static let kSegmentControlHeight: CGFloat = 30
    static let kSegmentControlVerticalPadding: CGFloat = 20
    static let kCellHeight: CGFloat = PerformanceChart.kHeight + PerformanceChartTableViewCell.kSegmentControlHeight + 2 * PerformanceChartTableViewCell.kSegmentControlVerticalPadding
    
    public var viewModel: PerformanceChartTableViewCellModel?
    public var chartMode: PerformanceChartMode = .Return
    
    public class var nib: UINib {
        get {
            return PerformanceChartTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return PerformanceChartTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupStyles()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.frame = bounds
        containerView.clipsToBounds = true
        
        setSubviewFrames()
    }
    
    public func setSubviewFrames() {
        // After shit has been laid out, do additional layout of subviews
        guard let performance = viewModel?.performance else { return }
//        performanceChart?.setup(performance)//)
        
        segmentControl.width = containerView.width - 100
        segmentControl.height = PerformanceChartTableViewCell.kSegmentControlHeight
        segmentControl.top = PerformanceChartTableViewCell.kSegmentControlVerticalPadding
        segmentControl.center.x = containerView.center.x
        
        lineChartView.width = containerView.width
        lineChartView.height = containerView.height - PerformanceChartTableViewCell.kSegmentControlHeight - 2 * PerformanceChartTableViewCell.kSegmentControlVerticalPadding
        lineChartView.top = segmentControl.bottom
        lineChartView.left = 0
    }
    
    public func updateChart() {
        guard let viewModel = viewModel else { return }
        let trades = viewModel.performance.trades
        
        let dates = trades.map { (trade) -> NSTimeInterval in
            return trade.date.timeIntervalSince1970
        }
        
        var cumulativeProfits: Double = 0
        
        var yData: [Double] = []
        let initialProfits: Double = 1000
        
        for trade in trades {
            cumulativeProfits += trade.profit
            if chartMode == .Return {
                yData.append(100 * cumulativeProfits/initialProfits)
            } else {
                yData.append(cumulativeProfits)
            }
            
        }
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dates.count {
            let dataEntry = ChartDataEntry(value: yData[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Date")
        let lineChartData = LineChartData(xVals: dates, dataSet: lineChartDataSet)
        lineChartData.setValueTextColor(Styles.Colors.Green)
        lineChartDataSet.setCircleColor(Styles.Colors.Green)
        lineChartDataSet.setColor(Styles.Colors.Green)
        lineChartDataSet.valueFont = Styles.Fonts.avenirRegularFontWithSize(10)
        lineChartDataSet.circleRadius = 3
        lineChartDataSet.fillColor = Styles.Colors.Green
        lineChartDataSet.drawCircleHoleEnabled = false
        
        
        let gradientColors = [Styles.Colors.Green.CGColor, Styles.Colors.Green.colorWithAlphaComponent(0).CGColor]
        guard let gradient = CGGradientCreateWithColors(nil, gradientColors, nil) else { return }
        
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fill = ChartFill(linearGradient: gradient, angle: -90)
        lineChartDataSet.drawFilledEnabled = true

        lineChartView.data = lineChartData
    }
    
    public func setup(viewModel: PerformanceChartTableViewCellModel) {
        self.viewModel = viewModel
        updateChart()
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        segmentControl.tintColor = Styles.Colors.Green
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.descriptionText = ""
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.labelFont = Styles.Fonts.avenirRegularFontWithSize(11)
        lineChartView.leftAxis.labelTextColor = Styles.Colors.Gray
        lineChartView.legend.enabled = false
        lineChartView.extraLeftOffset = 10
        lineChartView.extraRightOffset = 30
        
        if chartMode == .Return {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            lineChartView.leftAxis.valueFormatter = formatter
        } else {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            lineChartView.leftAxis.valueFormatter = formatter
        }
        
        lineChartView.leftAxis.axisMinValue = 0
        lineChartView.drawBordersEnabled = false
        lineChartView.leftAxis.minWidth = 30
    }
    
    @IBAction func tappedSegmentControl(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            chartMode = .Return
        } else {
            chartMode = .Profits
        }
        
        updateChart()
    }
}