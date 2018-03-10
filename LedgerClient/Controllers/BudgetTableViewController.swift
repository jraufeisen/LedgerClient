//
//  BudgetTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 09.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import UIKit

class BudgetTableViewController: UITableViewController {

    //Instance variables
    let ledger = LedgerModel.defaultModel()
    let categories = LedgerModel.defaultModel().categories()
    var budget = [String:Decimal]()

    //Constants
    let budgetAccount = Account.init(name: "Assets:Budget")
    let moneyAccount = Account.init(name:"Assets:Banking")

    override func viewDidLoad() {
        super.viewDidLoad()

        //Init values
        for cat in categories {
            let amount = ledger.budgetInCategory(category: cat)
            budget[cat] = amount
        }

        let budgeted = ledger.balanceForAccount(acc: budgetAccount)
        let owned = ledger.balanceForAccount(acc: moneyAccount)

        
        self.title = "You have \(owned - budgeted)€ to budget"
        
        print("You have budgeted \(ledger.balanceForAccount(acc: budgetAccount))€")
        print("You own  \(ledger.balanceForAccount(acc: moneyAccount))€")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath)

        //Set budget text
        let category = categories[indexPath.row]
        cell.textLabel?.text = category

        //Set amount of money in this budget category
        if let amount = budget[category] {
            cell.detailTextLabel?.text = "\(amount) €"
        } else {
            cell.detailTextLabel?.text = "NaN €"
        }

        
        
        return cell
    }
    

  

}
