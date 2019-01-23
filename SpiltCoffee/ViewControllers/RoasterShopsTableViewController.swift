//
//  RoasterShopsTableViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/4/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import MapKit

class RoasterShopsTableViewController: UITableViewController {
  
  //MARK: - IBOUTLETS
  @IBOutlet weak var shopMapView: MKMapView!
  @IBOutlet weak var phoneButton: UIButton!
  @IBOutlet weak var addressButton: UIButton!
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var addShopButton: UIButton!
  
  //MARK: - Properties
  var roaster: Roaster?{
    didSet{
      loadViewIfNeeded()
      updateViews()
    }
  }
  var shopAnnotations: [MKAnnotation] = []
  
  //MARK: - View LifeCylce Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    shopMapView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    updateViews()
  }
  
  //MARK: - Functions
  func updateViews(){
    if let roaster = roaster{
      dropAnnotations(for: roaster)
    }
    addShopButton.isHidden = !(roaster == UserController.shared.currentUser)
  }
  
  //MARK: - IBActions
  @IBAction func phoneButtonTapped(_ sender: Any) {
  }
  
  @IBAction func addressButtonTapped(_ sender: Any) {
  }
  
  @IBAction func emailButtonTapped(_ sender: Any) {
  }
  
}

//MARK: - MKMapViewDelegate
extension RoasterShopsTableViewController: MKMapViewDelegate{
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let shopAnnotation = view.annotation as? ShopAnnotation
    let shop = shopAnnotation?.shop
    phoneButton.setTitle(shop?.phone, for: .normal)
    addressButton.setTitle(shop?.address, for: .normal)
    emailButton.setTitle(shop?.email, for: .normal)
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
