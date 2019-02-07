//
//  ShopRoastersViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/16/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import MapKit

class ShopRoastersViewController: UIViewController {
    
    @IBOutlet weak var roasterCollectionView: UICollectionView!
    
    var roasterCollectionViewDataSource: DataViewGenericDataSource<Roaster>!
    
    var origin: Origin?{
        didSet{
            loadViewIfNeeded()
            self.title = origin?.name
            fetchRoasters(for: origin!)
        }
    }
    
    var roasters: [Roaster]?{
        didSet{
            if let roasters = roasters, !roasters.isEmpty{
                roasterCollectionViewDataSource = DataViewGenericDataSource(dataView: roasterCollectionView, dataType: .roaster, data: roasters)
                roasterCollectionViewDataSource.delegate = self
            }else{
                self.presentSimpleAlertWith(title: "Whoops looks like we don't have any roasters for \(origin?.name ?? "this search")", body: "This is Awkward...")
            }
            
        }
    }
    
    func fetchRoasters(for origin: Origin){
        FirestoreClient.shared.fetchAllObjectsWhere("origin", .equals, origin.name, orderedBy: nil, limitedTo: nil) { (beans: [CoffeeBean]?) in
            guard let beans = beans else { return }
            
            var roasterIdSet = Set<String>()
            for bean in beans{
                if let roasterId = bean.roasterAbridgedDictionary["uuid"] as? String{
                    roasterIdSet.insert(roasterId)
                }
            }
            
            FirestoreClient.shared.fetchAllFromFirestore(with: Array(roasterIdSet), completion: { (roasters: [Roaster]?) in
                self.roasters = roasters
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if origin == nil && roasters == nil{
            FirestoreClient.shared.fetchAllObjectsWhere("isFeatured", .equals, true, orderedBy: nil, limitedTo: nil) { (roasters: [Roaster]?) in
                self.roasters = roasters
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShopRoastersViewController: MKMapViewDelegate{
    
}
