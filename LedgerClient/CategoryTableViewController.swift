//
//  CategoryTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 03.10.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    
    let categories = LedgerManager.categories()
    var budget = [String:Decimal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categegories"
        
        //Init values
        for cat in categories {
            let amount = LedgerManager.availableBudget(category: cat)
            budget[cat] = amount
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryID", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category

        if let amount = budget[category] {
            cell.detailTextLabel?.text = "\(amount) €"
        } else {
            cell.detailTextLabel?.text = "NaN €"
        }
        return cell
    }
 

    //On selection: Go back to main transaction view with the selected category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = navigationController?.viewControllers.first as? AddTxTableViewController {
            controller.configureCategory(category: categories[indexPath.row])
        }
        
        navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
