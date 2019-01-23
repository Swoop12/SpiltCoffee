//
//  ProductCategoriesTableViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/15/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class ProductCategoriesTableViewController: UITableViewController {
    
    var categoriesDataSource: DataViewGenericDataSource<DesignCellData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesDataSource = DataViewGenericDataSource(dataView: self.tableView, dataType: .design, data: ConstantData.productCategories)
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = ConstantData.productCategories[indexPath.row]
        if category.name == "Bean"{
            self.performSegue(withIdentifier: "toShopBeans", sender: self)
        }else{
            performSegue(withIdentifier: "toShopProducts", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShopProducts"{
            let destinationVC = segue.destination as? ProductsTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let category = categoriesDataSource?.sourceOfTruth[indexPath.row]
            destinationVC?.category = category as? ConstantData
        }
    }
}
