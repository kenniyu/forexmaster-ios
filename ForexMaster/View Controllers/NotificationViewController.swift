//
//  NotificationViewController.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/25/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Firebase

public class NotificationViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var adBannerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    public var messageCellModels: [MessageTableViewCellModel] = []
    
    public override var navBarTitle: String {
        get {
            return "Messages"
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCells()
        setupTableView()
        setupAd()
    }
    
    public func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
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
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        FIRAnalytics.logEventWithName(FirebaseAnalytics.EventKeys.kNotificationScreenPageView, parameters: [
            "env": EnvironmentManager.sharedInstance.configuration
            ])
        
        fetchMessages()
    }
    
    public func fetchMessages() {
        let baseUrl = NetworkManager.sharedInstance.baseUrl
        // Do any additional setup after loading the view.
        let request = Alamofire.request(.GET, "\(baseUrl)/messages.json", parameters: nil, encoding: .JSON)
        spinner.startAnimating()
        request.responseJSON { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.spinner.stopAnimating()
            
            // Handle response here
            switch response.result {
            case .Success(let JSON):
                guard let positions = JSON as? [AnyObject] else { return }
                strongSelf.updateMessages(positions)
            default:
                break
            }
        }
    }

    public func registerCells() {
        tableView.registerNib(MessageTableViewCell.kNib, forCellReuseIdentifier: MessageTableViewCell.kReuseIdentifier)
    }
    
    public func updateMessages(messages: [AnyObject]) {
        messageCellModels = []
        for messagesJson in messages {
            if let message = Mapper<Message>().map(messagesJson) {
                let cellModel = MessageTableViewCellModel(message: message)
                messageCellModels.append(cellModel)
            }
        }
        tableView.reloadData()
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageCellModels.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(MessageTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? MessageTableViewCell {
            let messageCellModel = messageCellModels[indexPath.row]
            cell.setup(messageCellModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let messageCellModel = messageCellModels[indexPath.row]
        return MessageTableViewCell.size(tableView.width, viewModel: messageCellModel).height
    }
}