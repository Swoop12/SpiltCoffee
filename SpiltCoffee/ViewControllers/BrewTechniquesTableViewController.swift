//
//  BrewTechniquesTableViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/17/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class BrewTechniquesTableViewController: UITableViewController {
    
    var brewDataSource: DataViewGenericDataSource<DesignCellData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brewDataSource = DataViewGenericDataSource(dataView: self.tableView, dataType: DataType.design, data: BrewMethod.brewCategories)
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toBrewMethodDetailVC", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? BrewTechniqueDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let method = BrewMethod.brewCategories[indexPath.row]
        destinationVC?.brewMethod = method
    }
}
