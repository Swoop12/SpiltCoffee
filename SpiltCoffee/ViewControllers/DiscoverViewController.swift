//
//  ExploreViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/17/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import MapKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var roasterCollectionView: UICollectionView!
    @IBOutlet weak var shopMapView: MKMapView!
    
    var shopAnnotations: [MKAnnotation] = []
    
    var postsColletionViewDataSource: DataViewGenericDataSource<Post>!
    var roasterCollectioViewDataSource: DataViewGenericDataSource<Roaster>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopMapView.delegate = self
        shopMapView.showsUserLocation = true
        FirestoreClient.shared.fetchAllObjectsWhere("isFeatured", .equals, true, orderedBy: nil, limitedTo: nil) { (roasters: [Roaster]?) in
            guard let roasters = roasters else {return}
            roasters.forEach{ self.dropAnnotations(for: $0) }
            DispatchQueue.main.async {
                self.roasterCollectioViewDataSource = DataViewGenericDataSource(dataView: self.roasterCollectionView, dataType: .roaster, data: roasters)
                self.roasterCollectioViewDataSource.delegate = self
            }
        }
        
        FirestoreClient.shared.fetchAllObjectsWhere("date", FirestoreQuery.isLessThan, Date(), orderedBy: "date", limitedTo: 5) { (posts: [Post]?) in
            guard let posts = posts else { return }
            self.postsColletionViewDataSource = DataViewGenericDataSource<Post>(dataView: self.postsCollectionView, dataType: .post, data: posts)
            self.postsColletionViewDataSource.delegate = self
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

extension DiscoverViewController: MKMapViewDelegate{
    
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
    //        annotationView.canShowCallout = true
    //        return annotationView
    //    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? ShopAnnotation{
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.canShowCallout = true
            annotationView.tintColor = UIColor.mossGreen
            return annotationView
        }else{
            return nil
        }
    }
    
    
    func dropAnnotations(for roaster: Roaster){
        UserController.shared.getShops(for: roaster) { (shops) in
            guard let shops = shops else {return}
            let group = DispatchGroup()
            for shop in shops{
                group.enter()
                self.dropAnnotations(for: shop, completion: {
                    group.leave()
                })
            }
            group.notify(queue: .main, execute: {
                self.shopMapView.showAnnotations(self.shopAnnotations, animated: true)
            })
        }
    }
    
    func dropAnnotations(for shop: Shop, completion: @escaping () -> ()){
        if shop.coordinates != nil{
            let shopAnnotation = ShopAnnotation(shop: shop)
            self.shopMapView.addAnnotation(shopAnnotation)
            self.shopMapView.centerCoordinate = shop.coordinates!
            completion()
        }else{
            shop.getCooridnates { (coordinate) in
                guard coordinate != nil else { return }
                let shopAnnotation = ShopAnnotation(shop: shop)
                self.shopMapView.addAnnotation(shopAnnotation)
                self.shopAnnotations.append(shopAnnotation)
                completion()
            }
        }
    }
}

