//
//  TransactionTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class TransactionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LedgerModel.defaultModel.transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") else {return UITableViewCell() }
        
        let transaction = LedgerModel.defaultModel.transactions[indexPath.row]
        
        cell.textLabel?.text = transaction.name
        cell.detailTextLabel?.text =  String(format: "%.2f", (transaction.effectiveValue() as NSDecimalNumber).floatValue)

        if transaction.isExpense() {
            cell.detailTextLabel?.textColor = .red
        } else if transaction.isIncome() {
            cell.detailTextLabel?.textColor = .green
        }
        
        return cell
        
    }
    
    
  
}
