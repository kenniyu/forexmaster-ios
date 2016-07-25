//
//  HistoryTableHeaderView.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/25/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public enum HistoryFilter: Int {
    case Opening = 0
    case Adjustment
    case Closing
    case All
}

public protocol HistoryTableHeaderViewDelegate {
    func didChangeSegment(historyFilter: HistoryFilter)
}

public class HistoryTableHeaderView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    public static let kHeight: CGFloat = 50
    
    public var historyTableHeaderViewDelegate: HistoryTableHeaderViewDelegate?
    
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
        let nib = UINib(nibName: "HistoryTableHeaderView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        view.backgroundColor = UIColor.clearColor()
        
        // Adjust bounds
        view.frame = self.bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Add subview
        addSubview(self.view)
        
        layoutIfNeeded()
    }
    
    public func setupStyles() {
        containerView.backgroundColor = UIColor.clearColor()
        segmentControl.tintColor = Styles.Colors.Green
    }
    
    public func setup() {
        setupStyles()
    }
    
    @IBAction func changedSegment(sender: UISegmentedControl) {
        if let segmentTitle = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) {
            FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kFilteredHistory, parameters: [
                "segment_title": segmentTitle
            ])
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            historyTableHeaderViewDelegate?.didChangeSegment(.All)
        case 1:
            historyTableHeaderViewDelegate?.didChangeSegment(.Opening)
        case 2:
            historyTableHeaderViewDelegate?.didChangeSegment(.Adjustment)
        case 3:
            historyTableHeaderViewDelegate?.didChangeSegment(.Closing)
        default:
            return
        }
    }
}