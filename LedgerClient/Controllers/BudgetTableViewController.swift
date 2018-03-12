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
    var budget = [(Account, Decimal)]()

    //Constants
    let budgetAccount = Account.init(name: "Assets:Budget")
    let moneyAccount = Account.init(name:"Assets:Banking")

    override func viewDidLoad() {
        super.viewDidLoad()

        //Init values
        let budgeted = ledger.balanceForAccount(acc: budgetAccount)
        let owned = ledger.balanceForAccount(acc: moneyAccount)

        
        self.navigationItem.title = "You have \(owned - budgeted)€ to budget"
        
//        print("This is your budget: \(ledger.budgetAtMonth(date: Date()))")
    
        if let todaysBudget = ledger.budgetAtMonth(date: Date()) {
            budget = todaysBudget
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return budget.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath)

        //Set budget text
        let category = budget[indexPath.row].0
        cell.textLabel?.text = category.name.replacingOccurrences(of: "Assets:Budget:", with: "")

        //Set amount of money in this budget category
        cell.detailTextLabel?.text = "\(budget[indexPath.row].1) €"
        

        
        
        return cell
    }
    

  

}
