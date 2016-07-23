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

public class AccountSummaryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    public var performancesData: [Performance] = []
    public override var navBarTitle: String {
        get {
            return "Performance"
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override func setup() {
        super.setup()
        registerCells()
        
        fetchData()
    }
    
    public func fetchData() {
        let baseUrl = NetworkManager.sharedInstance.baseUrl
        let request = Alamofire.request(.GET, "\(baseUrl)/performance.json", encoding: .JSON)
        request.responseJSON { [weak self] (response) in
            guard let strongSelf = self else { return }
            
            // Handle response here
            switch response.result {
            case .Success(let JSON):
                guard let performances = JSON as? [[String: AnyObject]] else { return }
                strongSelf.updatePerformances(performances)
            default:
                break
            }
        }
    }
    
    public func updatePerformances(performances: [[String: AnyObject]]) {
        performancesData = []
        for performancesJson in performances {
            if let performance = Mapper<Performance>().map(performancesJson) {
                performancesData.append(performance)
            }
        }
        tableView.reloadData()
    }
    
    public func registerCells() {
        tableView.registerNib(PerformanceChartTableViewCell.kNib, forCellReuseIdentifier: PerformanceChartTableViewCell.kReuseIdentifier)
    }
}

extension AccountSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performancesData.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCellWithIdentifier(PerformanceChartTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? PerformanceChartTableViewCell {
                let viewModel = PerformanceChartTableViewCellModel(performance: performancesData[indexPath.row])
                cell.setup(viewModel)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PerformanceChartTableViewCell.kCellHeight
    }
}