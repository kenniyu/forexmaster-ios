//
//  PositionTableViewCell.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class PositionTableViewCellModel {
    var position: Position
    
    public init(position: Position) {
        self.position = position
    }
}

public enum PositionDataColumn: Int {
    case PnL = 0
    case CostBasis
    case Mark
    case Count
}

// Columns: P/L, Cost Basis, Mark

public protocol PositionTableViewCellDelegate {
    func didScrollScrollView(view: UIView, scrollViewOffset: CGFloat)
}

public class PositionTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalBorderView: UIView!
    @IBOutlet weak var pairLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: PositionTableViewCell.self))
    static let kClassName = "PositionTableViewCell"
    static let kReuseIdentifier = "PositionTableViewCell"
    static let kCellHeight: CGFloat = 65
    
    public var viewModel: PositionTableViewCellModel? = nil
    public var positionDataModels: [PositionDataCollectionViewCellModel] = []
    public var positionTableViewCellDelegate: PositionTableViewCellDelegate?
    
    public class var nib: UINib {
        get {
            return PositionTableViewCell.kNib
        }
    }
    
    public class var reuseId: String {
        get {
            return PositionTableViewCell.kClassName
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupStyles()
    }
    
    public func setup(viewModel: PositionTableViewCellModel) {
        self.viewModel = viewModel
        
        registerCells()
        setupCollectionView()
        setupColumnData(viewModel)
        loadDataIntoViews(viewModel)
    }
    
    public func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsetsZero
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func setupColumnData(viewModel: PositionTableViewCellModel) {
        positionDataModels = []
        let profitLoss = getProfitLoss()
        let costBasis = viewModel.position.costBasis
        let mark = viewModel.position.quote
        
        let profitLossModel = PositionDataCollectionViewCellModel(data: profitLoss, columnType: .PnL)
        let costBasisModel = PositionDataCollectionViewCellModel(data: costBasis, columnType: .CostBasis)
        let markModel = PositionDataCollectionViewCellModel(data: mark, columnType: .Mark)
        positionDataModels.append(profitLossModel)
        positionDataModels.append(costBasisModel)
        positionDataModels.append(markModel)
    }
    
    public func registerCells() {
        collectionView.registerNib(PositionDataCollectionViewCell.kNib, forCellWithReuseIdentifier: PositionDataCollectionViewCell.kReuseIdentifier)
    }
    
    public func loadDataIntoViews(viewModel: PositionTableViewCellModel) {
        pairLabel.text = viewModel.position.pair
        let size = viewModel.position.size
        if size > 0 {
            sizeLabel.textColor = Styles.Colors.Green
            sizeLabel.text = "+\(viewModel.position.size)"
        } else {
            sizeLabel.textColor = Styles.Colors.Red
            sizeLabel.text = "\(viewModel.position.size)"
        }
        collectionView.reloadData()
    }
    
    public func setupStyles() {
        selectionStyle = .None
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = backgroundColor
        containerView.backgroundColor = Styles.Colors.White
        
        pairLabel.font = Styles.Fonts.avenirDemiBoldFontWithSize(16)
        pairLabel.textColor = Styles.Colors.Black
        sizeLabel.font = Styles.Fonts.avenirRegularFontWithSize(13)
        
        verticalBorderView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
    }
    
    public func getProfitLoss() -> String {
        guard let viewModel = viewModel else { return "-" }
        guard let mark = viewModel.position.quote?.quote else { return "-" }
        guard let costBasis = Double(viewModel.position.costBasis) else { return "-" }
        let size = Double(viewModel.position.size)
        
        let profitLoss = size * (mark - costBasis)
        return String(profitLoss)
    }
}

extension PositionTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PositionDataCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? PositionDataCollectionViewCell {
            let positionDataModel = positionDataModels[indexPath.item]
            cell.setup(positionDataModel)
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PositionDataColumn.Count.rawValue
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, PositionTableViewCell.kCellHeight - 10)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}

extension PositionTableViewCell: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let horizontalOffset = scrollView.contentOffset.x
        positionTableViewCellDelegate?.didScrollScrollView(self, scrollViewOffset: horizontalOffset)
    }
}
