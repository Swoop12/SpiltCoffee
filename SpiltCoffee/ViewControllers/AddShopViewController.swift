//
//  AddShopViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/28/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import MapKit

class AddShopViewController: UIViewController, MKLocalSearchCompleterDelegate {

    @IBOutlet weak var addressSearchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var searchResults: [MKLocalSearchCompletion] = []
    
    var searchCompleter = MKLocalSearchCompleter()
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        print(searchResults.compactMap{ $0.title })
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressSearchBar.delegate = self
        searchCompleter.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        if let currentLocation = UserController.shared.currentLocation?.coordinate{
            searchCompleter.region = MKCoordinateRegion(center: currentLocation, span: span)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddShopViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        let location = searchResults[indexPath.row]
        cell.textLabel?.text = location.title
        cell.detailTextLabel?.text = location.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = searchResults[indexPath.row]
        presentAlertController(for: location)
        
    }
    
    func presentAlertController(for location: MKLocalSearchCompletion){
        let alertController = UIAlertController(title: "Create New Shop", message: location.title, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Email?"
        }
        alertController.addTextField { (phoneTextField) in
            phoneTextField.placeholder = "Phone Number?"
            phoneTextField.keyboardType = .numberPad
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let email = alertController.textFields?.first?.text,
                let phone = alertController.textFields?[1].text else {return}
            ShopController.shared.addShopToCurrentUserWith(address: "\(location.title), \(location.subtitle)", email: email, phone: phone, completion: { (shop) in
                guard let _ = shop else {print("failed to save shop") ; return}
                self.dismiss(animated: true, completion: nil)
            })
        }
        
        let dimissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(dimissAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true)
    }
}

extension AddShopViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
}
