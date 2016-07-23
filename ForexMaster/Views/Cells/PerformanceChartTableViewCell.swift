//
//  PerformanceChartTableViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/22/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit


public class PerformanceChartTableViewCellModel {
    var performance: Performance
    public init(performance: Performance) {
        self.performance = performance
    }
}


public class PerformanceChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    public var performanceChart: PerformanceChart? = nil
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: PerformanceChartTableViewCell.self))
    static let kClassName = "PerformanceChartTableViewCell"
    static let kReuseIdentifier = "PerformanceChartTableViewCell"
    static let kSegmentControlHeight: CGFloat = 30
    static let kSegmentControlVerticalPadding: CGFloat = 20
    static let kCellHeight: CGFloat = PerformanceChart.kHeight + PerformanceChartTableViewCell.kSegmentControlHeight + 2 * PerformanceChartTableViewCell.kSegmentControlVerticalPadding
    
    public var viewModel: PerformanceChartTableViewCellModel?
    
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
        performanceChart?.setup()//)
        
        segmentControl.width = containerView.width - 100
        segmentControl.height = PerformanceChartTableViewCell.kSegmentControlHeight
        segmentControl.top = PerformanceChartTableViewCell.kSegmentControlVerticalPadding
        segmentControl.center.x = containerView.center.x
    }
    
    public func loadDataIntoViews(viewModel: PerformanceChartTableViewCellModel) {
    }
    
    public func setup(viewModel: PerformanceChartTableViewCellModel) {
        self.viewModel = viewModel
        loadDataIntoViews(viewModel)
        
        if let performanceChart = performanceChart {
            print("GOT HERE")
        } else {
            let performanceChartTop = PerformanceChartTableViewCell.kSegmentControlHeight + 2 * PerformanceChartTableViewCell.kSegmentControlVerticalPadding
            let performanceChartFrame = CGRectMake(0, performanceChartTop, containerView.width, PerformanceChart.kHeight)
            performanceChart = PerformanceChart(frame: performanceChartFrame)
            if let performanceChart = performanceChart {
                containerView.addSubview(performanceChart)
            }
        }
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        segmentControl.tintColor = Styles.Colors.Green
    }
}