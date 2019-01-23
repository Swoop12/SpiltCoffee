//
//  RoasterProfileContentViewController.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock.
//  Copyright © 2018 DevMountain. All rights reserved.
//


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
// MARK: - Import

import UIKit


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
// MARK: - Class

class RoasterProfileViewController: UIViewController {


    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    // MARK: - Properties

    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var roasterNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var productsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var shopsContainerView: UIView!
    @IBOutlet weak var productContainerView: UIView!
    
    var roaster: Roaster?{
        didSet{
            updateView()
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        segmentedControl.selectedSegmentIndex = 0
        presentTableViewFor(selectedSegementIndex: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar, if any
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func updateView(){
        guard let roaster = roaster else {return}
        roasterNameLabel.text = roaster.name
        
        if let coverPhoto = roaster.coverPhoto{
            coverPhotoImageView.image = coverPhoto
        }
        
        if let profilePicture = roaster.profilePicture{
            profilePictureImageView.image = profilePicture
        }
        
        if !roaster.shops.isEmpty{
            locationLabel.text = "\(roaster.shops.first!.city), \(roaster.shops.first!.state)"
        }
        
        if let company = roaster.companyName{
            companyLabel.text = company
        }
        
        productsLabel.text = "\(roaster.products.count)"
        followingLabel.text = "\(roaster.following.count) "
        followersLabel.text = "\(roaster.followers.count)"
        postsLabel.text = "\(roaster.post.count)"
    }

    fileprivate func setupUI() {
        // Navigation bar
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 17)!,
            NSForegroundColorAttributeName : UIColor(red: 0.36, green: 0.51, blue: 0.46, alpha: 1)
        ]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // coverImageViewImageView
        self.coverPhotoImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.coverPhotoImageView.layer.shadowRadius = 2.0
        self.coverPhotoImageView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.coverPhotoImageView.layer.shadowOpacity = 1.0
        self.coverPhotoImageView.layer.masksToBounds = false

        
        // profileImageViewImageView
        self.profilePictureImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.profilePictureImageView.layer.shadowRadius = 2.0
        self.profilePictureImageView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.profilePictureImageView.layer.shadowOpacity = 1.0
        self.profilePictureImageView.layer.masksToBounds = false
        
        // Configure the base attributed string for roasterNameLabelLabel
        let roasterNameLabelLabelAttrString = NSMutableAttributedString(string: "Larry Nichols", attributes: [
        	NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        	NSFontAttributeName : UIFont(name: "AvenirNext-DemiBold", size: 28)!,
        	NSKernAttributeName : 0.34,
        	NSParagraphStyleAttributeName: NSMutableParagraphStyle(alignment: .left, lineHeight: nil, paragraphSpacing: 0)
        ])
        self.roasterNameLabel.attributedText = roasterNameLabelLabelAttrString
        
        // Configure the base attributed string for locationLabelLabel
        let locationLabelLabelAttrString = NSMutableAttributedString(string: "Seattlle, WA", attributes: [
        	NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        	NSFontAttributeName : UIFont(name: "Avenir-BookOblique", size: 14)!,
        	NSKernAttributeName : 0.25,
        	NSParagraphStyleAttributeName: NSMutableParagraphStyle(alignment: .right, lineHeight: nil, paragraphSpacing: 0)
        ])
        self.locationLabel.attributedText = locationLabelLabelAttrString
        
        // Configure the base attributed string for companyLabelLabel
        let companyLabelLabelAttrString = NSMutableAttributedString(string: "Independent Roaster", attributes: [
        	NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        	NSFontAttributeName : UIFont(name: "Avenir-BookOblique", size: 14)!,
        	NSKernAttributeName : 0.25,
        	NSParagraphStyleAttributeName: NSMutableParagraphStyle(alignment: .left, lineHeight: nil, paragraphSpacing: 0)
        ])
        self.companyLabel.attributedText = companyLabelLabelAttrString
        
        
        // Configure the base attributed string for followingLabel
        let followingLabelAttrString = NSMutableAttributedString(string: "following", attributes: [
        	NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        	NSFontAttributeName : UIFont(name: "AvenirNext-Regular", size: 9)!,
        	NSKernAttributeName : 0.16,
        	NSParagraphStyleAttributeName: NSMutableParagraphStyle(alignment: .center, lineHeight: nil, paragraphSpacing: 0)
        ])
        self.followingLabel.attributedText = followingLabelAttrString
        
        // Configure the base attributed string for followersLabel
        let followersLabelAttrString = NSMutableAttributedString(string: "followers", attributes: [
        	NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        	NSFontAttributeName : UIFont(name: "AvenirNext-Regular", size: 9)!,
        	NSKernAttributeName : 0.16,
        	NSParagraphStyleAttributeName: NSMutableParagraphStyle(alignment: .center, lineHeight: nil, paragraphSpacing: 0)
        ])
        self.followersLabel.attributedText = followersLabelAttrString
        
        // Configure the base attributed string for bookmarksLabel
        let bookmarksLabelAttrString = NSMutableAttributedString(string: "bookmarks", attributes: [
        	NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        	NSFontAttributeName : UIFont(name: "AvenirNext-Regular", size: 9)!,
        	NSKernAttributeName : 0.16,
        	NSParagraphStyleAttributeName: NSMutableParagraphStyle(alignment: .center, lineHeight: nil, paragraphSpacing: 0)
        ])
        self.postsLabel.attributedText = bookmarksLabelAttrString
    }



    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    // MARK: - Status bar

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    // MARK: - Actions

    @IBAction func onSegmentedControlViewValueChanged(_ sender: UISegmentedControl) {
        presentTableViewFor(selectedSegementIndex: sender.selectedSegmentIndex)
    }
    
    func presentTableViewFor(selectedSegementIndex: Int){
        switch selectedSegementIndex {
        case 0:
            contentContainerView.isHidden = false
            shopsContainerView.isHidden = true
            productContainerView.isHidden = true
        case 1:
            contentContainerView.isHidden = true
            shopsContainerView.isHidden = true
            productContainerView.isHidden = false
        case 2:
            contentContainerView.isHidden = true
            shopsContainerView.isHidden = false
            productContainerView.isHidden = true
        default:
            contentContainerView.isHidden = false
            shopsContainerView.isHidden = true
            productContainerView.isHidden = true
        }
    }
}
