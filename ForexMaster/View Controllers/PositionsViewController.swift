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
import SWXMLHash
import FirebaseAnalytics

public class PositionsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var adBannerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    public var positionsData: [Position] = []
    public var quotesData: [String: String] = [:]
    public var quoteRefreshTimer: NSTimer? = nil
    
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
        
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kPositionsScreenPageView, parameters: [
            "env": EnvironmentManager.sharedInstance.configuration
        ])
        fetchTrades()
        fetchQuotes()
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
        setupAd()
        setupQuoteRefresh()
    }
    
    public func setupQuoteRefresh() {
        quoteRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: #selector(PositionsViewController.pollQuotes), userInfo: nil, repeats: true)
    }
    
    public func pollQuotes() {
        fetchQuotes()
    }
    
    public func fetchTrades() {
        // Do any additional setup after loading the view.
        let baseUrl = NetworkManager.sharedInstance.baseUrl
        let request = Alamofire.request(.GET, "\(baseUrl)/trades.json", parameters: nil, encoding: .JSON, headers: nil)
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
        
        // Now that we have all positions, make query to fetch all quotes
        fetchQuotes()
        tableView.reloadData()
    }
    
    public func updateQuotes() {
        // Update quote value in positions, and then reloads the table
        for position in positionsData {
            let pair = position.pair
            if let quote = quotesData[pair] {
                position.quote = quote
            }
        }
        tableView.reloadData()
    }
    
    public func fetchQuotes() {
        print("Fetching quotes")
        
        let pairs = positionsData.map { (position) -> String in
            return position.pair
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, "https://rates.fxcm.com/RatesXML", parameters: nil).response { [weak self] (request, response, data, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            guard let strongSelf = self else { return }
            if let data = data {
                let xml = SWXMLHash.parse(data)
                
                for pair in pairs {
                    let pairString = pair.componentsSeparatedByString("/").joinWithSeparator("")
                    do {
                        let bid = try xml["Rates"]["Rate"].withAttr("Symbol", pairString)["Bid"].element?.text
                        do {
                            let ask = try xml["Rates"]["Rate"].withAttr("Symbol", pairString)["Ask"].element?.text
                            
                            if let bid = bid, ask = ask, bidDouble = Double(bid), askDouble = Double(ask) {
                                let mark = (bidDouble + askDouble)/2
                                strongSelf.quotesData[pair] = String(mark)
                            }
                        } catch {
                            print("WTF")
                        }
                    } catch {
                        print("WTF")
                    }
                }
            }
            strongSelf.updateQuotes()
        }
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