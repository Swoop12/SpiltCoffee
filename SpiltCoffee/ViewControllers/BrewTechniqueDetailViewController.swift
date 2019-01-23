//
//  BrewTechniqueDetailViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/17/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class BrewTechniqueDetailViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var recepiesCollectionView: UICollectionView!
    @IBOutlet weak var videoPlayerView: RecepieVideoView!
    
    var recepiesDataSource: DataViewGenericDataSource<Recepie>!
    
    var brewMethod: BrewMethod?{
        didSet{
            loadViewIfNeeded()
            fetchRecepiesForBrewMethod()
            updateViews()
            videoPlayerView.viewController = self
        }
    }
    
    var recepies: [Recepie]?{
        didSet{
            recepiesDataSource = DataViewGenericDataSource(dataView: recepiesCollectionView, dataType: DataType.recepie, data: recepies!)
            recepiesDataSource.delegate = self
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPlayerView.player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoPlayerView.player?.pause()
    }
    
    func fetchRecepiesForBrewMethod(){
        guard let brewMethod = brewMethod else { return }
        FirestoreClient.shared.fetchAllObjectsWhere("brewMethod", .equals, brewMethod.name, orderedBy: nil, limitedTo: 10) { (recepies: [Recepie]?) in
            self.recepies = recepies
        }
    }
    
    func updateViews(){
        aboutTextView.text = brewMethod?.about
        self.title = brewMethod?.name
        videoPlayerView.videoUrlString = brewMethod?.url
    }
}
