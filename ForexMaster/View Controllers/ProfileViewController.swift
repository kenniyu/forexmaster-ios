//
//  ProfileViewController.swift
//  LittleFormosa
//
//  Created by Ken Yu on 7/16/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class ProfileViewController: BaseViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageViewTopConstraint: NSLayoutConstraint!
    
    var profileViewModel: ProfileViewModel? = nil
    var profileDetailsViewModel: ProfileDetailsViewModel? = nil
    
    public var cellModels: [[ProfileDetailsViewModel]] = []
    
    public override class var kNibName: String {
        get {
            return "ProfileViewController"
        }
    }
    
    public override var navBarTitle: String {
        get {
            if let profileViewModel = profileViewModel {
                return profileViewModel.name
            }
            return "Profile"
        }
    }
    
    public convenience init(profileViewModel: ProfileViewModel) {
        self.init()
        self.profileViewModel = profileViewModel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateCellModels()
        tableView.reloadData()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.sendSubviewToBack(profileImageView)
    }
    
    public override func setup() {
        super.setup()
        
        if let profileViewModel = profileViewModel {
            let tableHeaderView = ProfileHeaderView(frame: CGRectMake(0, 0, tableView.width, ProfileHeaderView.kHeight))
            tableHeaderView.setup(profileViewModel)
            tableView.tableHeaderView = tableHeaderView
        }
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = UIColor.clearColor()
        
        setupProfilePicture()
        registerCells()
    }
    
    public func setupProfilePicture() {
        profileImageView.image = profileViewModel?.image
        profileImageView.clipsToBounds = true
    }
    
    public func registerCells() {
        tableView.registerNib(ProfileStatsTableViewCell.kNib, forCellReuseIdentifier: ProfileStatsTableViewCell.kReuseIdentifier)
        tableView.registerNib(ProfileEmployersTableViewCell.kNib, forCellReuseIdentifier: ProfileEmployersTableViewCell.kReuseIdentifier)
        tableView.registerNib(ProfileEducationsTableViewCell.kNib, forCellReuseIdentifier: ProfileEducationsTableViewCell.kReuseIdentifier)
    }
    
    public func updateCellModels() {
        cellModels = []
        
        guard let profileViewModel = profileViewModel else { return }
        
        // Use profile details view model to construct all cell models
        self.profileDetailsViewModel = ProfileDetailsViewModel(name: profileViewModel.name, headline: profileViewModel.headline, profileImage: profileViewModel.image, height: 120, age: 24, salary: 240000, employer: "LinkedIn", educations: ["UC Berkeley", "Harvard"])
        
        if let profileDetailsViewModel = self.profileDetailsViewModel {
            // Make stats section
            let statsSection = [profileDetailsViewModel]
            cellModels.append(statsSection)
            
            // Make employment section
            let employerSection = [profileDetailsViewModel]
            cellModels.append(employerSection)
            
            let educationSection = [profileDetailsViewModel]
            cellModels.append(educationSection)
        }
        
        
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellModels.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels[section].count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ProfileStatsTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? ProfileStatsTableViewCell {
                let viewModel = cellModels[indexPath.section][indexPath.row]
                cell.setup(viewModel)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ProfileEmployersTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? ProfileEmployersTableViewCell {
                let viewModel = cellModels[indexPath.section][indexPath.row]
                cell.setup(viewModel)
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCellWithIdentifier(ProfileEducationsTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? ProfileEducationsTableViewCell {
                let viewModel = cellModels[indexPath.section][indexPath.row]
                cell.setup(viewModel)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return ProfileStatsTableViewCell.kCellHeight
        case 1:
            return ProfileEmployersTableViewCell.kCellHeight
        case 2:
            return ProfileEducationsTableViewCell.kCellHeight
        default:
            break
        }
        return 0
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let relaxedOffset = -1 * scrollView.contentInset.top
        profileImageViewHeightConstraint.constant = max(ProfileHeaderView.kHeight, ProfileHeaderView.kHeight + (-1 * scrollView.contentOffset.y - abs(relaxedOffset)))
        
        profileImageViewTopConstraint.constant = abs(relaxedOffset)
        if scrollView.contentOffset.y > relaxedOffset {
            // image should move up at half the speed
            profileImageViewTopConstraint.constant = abs(relaxedOffset) - (scrollView.contentOffset.y - relaxedOffset)/2
        }

    }
    
    /*
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let relaxedOffset = -1 * tableView.contentInset.top
        if relaxedOffset - scrollView.contentOffset.y > TripDetailsV2ViewController.kImageHintViewDragThreshold {
            presentAircraftPhotoBrowser()
        }
    }
    
    public func toggleImageHintView(scrollView: UIScrollView) {
        let relaxedOffset = -1 * tableView.contentInset.top
        if relaxedOffset - scrollView.contentOffset.y > TripDetailsV2ViewController.kImageHintViewDragThreshold {
            UIView.animateWithDuration(TripDetailsV2ViewController.kImageHintViewAnimationDuration, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.imageHintView.alpha = 1
                })
        } else {
            UIView.animateWithDuration(TripDetailsV2ViewController.kImageHintViewAnimationDuration, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.imageHintView.alpha = 0
                })
        }
    }
    
    
    public func presentAircraftPhotoBrowser() {
        guard let aircraft = tripOption?.aircraft else { return }
        guard let images = (aircraft.images ?? aircraft.imagesHighRes) where images.count > 0 else { return }
        
        var photos: [IDMPhoto] = []
        for url in images {
            let photo = IDMPhoto(URL: NSURL(string: url))
            photos.append(photo)
        }
        
        let photoBrowser = AircraftPhotoBrowser(photos: photos)
        photoBrowser.delegate = self
        photoBrowser.displayActionButton = false
        photoBrowser.displayArrowButton = false
        photoBrowser.usePopAnimation = true
        photoBrowser.displayCounterLabel = true
        photoBrowser.doneButtonImage = UIImage().imageWithColor(UIColor.whiteColor(), size: CGSizeMake(100, 50))
        presentViewController(photoBrowser, animated: true, completion: nil)
    }*/
}