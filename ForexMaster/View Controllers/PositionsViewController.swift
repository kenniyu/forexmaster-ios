//
//  PositionsViewController.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import GoogleMobileAds

public class PositionsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var adBannerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    public var positionsData: [Position] = []
    
    public override var navBarTitle: String {
        get {
            return "Positions"
        }
    }
    
    public override func setupStyles() {
        super.setupStyles()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupAd()
        fetchTrades()
    }
    
    public func setupAd() {
        if ExperimentManager.sharedInstance.showAds {
            bannerView.adUnitID = "ca-app-pub-9772342513376923/5943289897"
            bannerView.rootViewController = self
            
            let request = GADRequest()
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
    }
    
    public func fetchTrades() {
        // Do any additional setup after loading the view.
        let request = Alamofire.request(.GET, "https://fast-forest-93779.herokuapp.com/trades.json", parameters: nil, encoding: .JSON, headers: nil)
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
        tableView.registerNib(PositionTableViewCell.kNib, forCellReuseIdentifier: PositionTableViewCell.kReuseIdentifier)
    }
    
    public func updatePositions(positions: [[String: AnyObject]]) {
        positionsData = []
        for positionJson in positions {
            if let position = Mapper<Position>().map(positionJson) {
                positionsData.append(position)
            }
        }
        tableView.reloadData()
    }
}

extension PositionsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionsData.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(PositionTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? PositionTableViewCell {
            let viewModel = PositionTableViewCellModel(position: positionsData[indexPath.row])
            cell.setup(viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PositionTableViewCell.kCellHeight
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PositionSectionHeaderView(frame: CGRectMake(0, 0, tableView.width, PositionSectionHeaderView.kHeight))
        view.setup()
        return view
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return PositionSectionHeaderView.kHeight
    }
}