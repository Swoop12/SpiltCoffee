//
//  OriginTableViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/16/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class OriginTableViewController: UITableViewController {
  
  @IBOutlet weak var originSearchBar: UISearchBar!
  
  var isSearching: Bool! = false
  var filteredOrigins: [Origin] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isSearching = false
    originSearchBar.delegate = self
  }
  
  //    override func viewWillAppear(_ animated: Bool) {
  //        super.viewWillAppear(animated)
  //        tableView.reloadData()
  //    }
  ////
  //    override func viewDidDisappear(_ animated: Bool) {
  //        super.viewDidDisappear(animated)
  //        originSearchBar.text = ""
  //        isSearching = false
  //      tableView.reloadData()
  //    }
  
  // MARK: - Table view data soure
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isSearching ? filteredOrigins.count : Origin.countries.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "originCell", for: indexPath) as? OriginTableViewCell
    var origin: Origin!
    if isSearching{
      origin = filteredOrigins[indexPath.row]
    }else{
      origin = Origin.countries[indexPath.row]
    }
    // Configure the cell...
    cell?.origin = origin
    return cell ?? UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toRoastersVC"{
      let destinationVC = segue.destination as? ShopRoastersViewController
      guard let indexPath = tableView.indexPathForSelectedRow else {return}
      
      var origin: Origin!
      if isSearching{
        origin = filteredOrigins[indexPath.row]
      }else{
        origin = Origin.countries[indexPath.row]
      }
      destinationVC?.origin = origin
    }
  }
}

extension OriginTableViewController: UISearchBarDelegate{
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    isSearching = false
    tableView.reloadData()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == ""{
      isSearching = false
    }else {
      isSearching = true
      filteredOrigins = Origin.countries.filter{ $0.name.contains(searchText) }
    }
    tableView.reloadData()
  }
}
