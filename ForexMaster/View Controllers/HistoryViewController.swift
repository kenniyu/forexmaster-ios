//
//  HistoryViewController.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import GoogleMobileAds
import FirebaseAnalytics

public class HistoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var adBannerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    public var tradesData: [Trade] = []
    public var filteredTradesData: [Trade] = []
    public var historyFilter: HistoryFilter = .All
    
    public override var navBarTitle: String {
        get {
            return "History"
        }
    }
    
    public func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let tableHeaderView = HistoryTableHeaderView(frame: CGRectMake(0, 0, tableView.width, HistoryTableHeaderView.kHeight))
        tableHeaderView.setup()
        tableHeaderView.historyTableHeaderViewDelegate = self
        tableView.tableHeaderView = tableHeaderView
    }
    
    public override func setupStyles() {
        super.setupStyles()
        setupTableView()
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kHistoryScreenPageView, parameters: [
            "env": EnvironmentManager.sharedInstance.configuration
        ])
        fetchTrades()
    }
    
    public func setupAd() {
        if ExperimentManager.sharedInstance.showAds {
            bannerView.adUnitID = "ca-app-pub-9772342513376923/5943289897"
            bannerView.rootViewController = self
            
            let request = GADRequest()
            request.contentURL = "https://www.fxcm.com/insights/markets/"
            request.testDevices = [kDFPSimulatorID, "ffe7748b1c0b67e1e502538e4e814a4228f5a25f"]
            bannerView.loadRequest(request)
        } else {
            bannerView.hidden = true
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if ExperimentManager.sharedInstance.showAds {
            adBannerTopConstraint.constant = topBarHeight()
            tableViewTopConstraint.constant = bannerView.height
        } else {
            view.bringSubviewToFront(tableView)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupAd()
    }
    
    public func fetchTrades() {
        let baseUrl = NetworkManager.sharedInstance.baseUrl
        // Do any additional setup after loading the view.
        let request = Alamofire.request(.GET, "\(baseUrl)/trades_history.json", parameters: nil, encoding: .JSON, headers: nil)
        spinner.startAnimating()
        request.responseJSON { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.spinner.stopAnimating()
            
            // Handle response here
            switch response.result {
            case .Success(let JSON):
                guard let positions = JSON as? [[String: AnyObject]] else { return }
                strongSelf.updatePositions(positions)
            default:
                break
            }
        }
    }
    
    public func registerCells() {
        tableView.registerNib(HistoryTableViewCell.kNib, forCellReuseIdentifier: HistoryTableViewCell.kReuseIdentifier)
    }
    
    public func updatePositions(trades: [[String: AnyObject]]) {
        tradesData = []
        for tradesJson in trades {
            if let trade = Mapper<Trade>().map(tradesJson) {
                tradesData.append(trade)
            }
        }
        
        // filter
        filterTrades()
        tableView.reloadData()
    }
    
    public func filterTrades() {
        filteredTradesData = []
        for tradeData in tradesData {
            if historyFilter == .All {
                filteredTradesData.append(tradeData)
            } else {
                if tradeData.status == historyFilter.rawValue {
                    filteredTradesData.append(tradeData)
                }
            }
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTradesData.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? HistoryTableViewCell {
            let viewModel = HistoryTableViewCellModel(trade: filteredTradesData[indexPath.row])
            cell.setup(viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HistoryTableViewCell.kCellHeight
    }
}

extension HistoryViewController: HistoryTableHeaderViewDelegate {
    public func didChangeSegment(historyFilter: HistoryFilter) {
        self.historyFilter = historyFilter
        filterTrades()
        tableView.reloadData()
    }
}