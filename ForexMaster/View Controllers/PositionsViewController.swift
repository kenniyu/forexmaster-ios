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

public class PositionsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
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
        
        fetchTrades()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    public func fetchTrades() {
        // Do any additional setup after loading the view.
        let request = Alamofire.request(.GET, "https://fast-forest-93779.herokuapp.com/trades.json", parameters: nil, encoding: .JSON, headers: nil)
        request.responseJSON { [weak self] response in
            guard let strongSelf = self else { return }
            
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