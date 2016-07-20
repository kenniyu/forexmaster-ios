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

public class HistoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var adBannerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    public var tradesData: [Trade] = []
    
    public override var navBarTitle: String {
        get {
            return "History"
        }
    }
    
    public override func setupStyles() {
        super.setupStyles()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchTrades()
    }
    
    public func setupAd() {
        if ExperimentManager.sharedInstance.showAds {
            bannerView.adUnitID = "ca-app-pub-9772342513376923/5943289897"
            bannerView.rootViewController = self
            
            let request = GADRequest()
            request.contentURL = "http://www.forexfactory.com/"
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
        // Do any additional setup after loading the view.
        let request = Alamofire.request(.GET, "https://fast-forest-93779.herokuapp.com/trades_history.json", parameters: nil, encoding: .JSON, headers: nil)
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
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradesData.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? HistoryTableViewCell {
            let viewModel = HistoryTableViewCellModel(trade: tradesData[indexPath.row])
            cell.setup(viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HistoryTableViewCell.kCellHeight
    }
}