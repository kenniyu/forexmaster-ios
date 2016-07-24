//
//  AccountSummaryViewController.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/22/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Firebase

public class AccountSummaryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var adBannerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    public var performanceData: Performance?
    
    public override var navBarTitle: String {
        get {
            return "Account"
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupAd()
    }
    
    public override func setup() {
        super.setup()
        registerCells()
        
        setupTableView()
        
        requestPushNotificationAccess()
    }
    
    public func requestPushNotificationAccess() {
        let hasViewedPushNotificationHint = NSUserDefaults.standardUserDefaults().boolForKey("pushHint")
        if !hasViewedPushNotificationHint {
            let viewController = PushNotificationViewController()
            viewController.pushNotificationViewControllerDelegate = self
            viewController.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            viewController.modalPresentationStyle = .OverCurrentContext
            viewController.modalTransitionStyle = .CrossDissolve
            tabBarController?.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kPerformanceScreenPageView, parameters: [
            "env": EnvironmentManager.sharedInstance.configuration
            ])
        fetchData()
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
    
    public func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    public func fetchData() {
        spinner.startAnimating()
        let baseUrl = NetworkManager.sharedInstance.baseUrl
        let request = Alamofire.request(.GET, "\(baseUrl)/performance.json", encoding: .JSON)
        request.responseJSON { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.spinner.stopAnimating()
            
            // Handle response here
            switch response.result {
            case .Success(let JSON):
                guard let performanceJson = JSON as? [String: AnyObject] else { return }
                strongSelf.performanceData = Mapper<Performance>().map(performanceJson)
                strongSelf.tableView.reloadData()
            default:
                break
            }
        }
    }
    
    public func registerCells() {
        tableView.registerNib(PerformanceChartTableViewCell.kNib, forCellReuseIdentifier: PerformanceChartTableViewCell.kReuseIdentifier)
        tableView.registerNib(AccountSummaryTableViewCell.kNib, forCellReuseIdentifier: AccountSummaryTableViewCell.kReuseIdentifier)
        tableView.registerClass(BaseTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: BaseTableViewHeaderFooterView.kReuseIdentifier)
        
    }
}

extension AccountSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = performanceData {
            return 1
        }
        return 0
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCellWithIdentifier(AccountSummaryTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? AccountSummaryTableViewCell {
                if let performanceData = performanceData {
                    let viewModel = AccountSummaryTableViewCellModel(
                        inceptionDate: performanceData.inceptionDate,
                        initialBalance: performanceData.initialBalance,
                        settledProfits: performanceData.settledProfits,
                        returnPct: performanceData.returnPct)
                    cell.setup(viewModel)
                    return cell
                }
            }
        case 1:
            if let cell = tableView.dequeueReusableCellWithIdentifier(PerformanceChartTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? PerformanceChartTableViewCell {
                if let performanceData = performanceData {
                    let viewModel = PerformanceChartTableViewCellModel(performance: performanceData)
                    cell.setup(viewModel)
                    return cell
                }
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return AccountSummaryTableViewCell.kCellHeight
        case 1:
            return PerformanceChartTableViewCell.kCellHeight
        default:
            break
        }
        return 0
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(BaseTableViewHeaderFooterView.kReuseIdentifier) as? BaseTableViewHeaderFooterView {
            switch section {
            case 0:
                headerView.setup("Account Summary")
            case 1:
                headerView.setup("Performance")
            default:
                break
            }
            return headerView
        }
        return UIView()
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return BaseTableViewHeaderFooterView.kHeight
    }
}

extension AccountSummaryViewController: PushNotificationViewControllerDelegate {
    public func didConfirmPushNotifications() {
        // Push notifications
        AppDelegate.registerForPushNotifications(UIApplication.sharedApplication())
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "pushHint")
    }
    
    public func didRejectPushNotifications() {
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "pushHint")
    }
}