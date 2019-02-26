//
//  AddTxTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 03.10.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit


///The two possible cases for an entry: Income and Expense
public enum NumberContext {
    case Expense
    case Income
    case Transfer
}


///This struct will be used to pass relevant context information to upfollowing interface controllers
public struct EntryContext {
    var type: NumberContext?
    var money: String?
    var account: String?
    var budgetCategory: String?
    var description: String?
    
    init(type: NumberContext? = nil, money: String? = nil, account: String? = nil, budgetCategory: String? = nil, description: String? = nil) {
        self.type = type
        self.money = money
        self.account = account
        self.budgetCategory = budgetCategory
        self.description = description
    }
}






class AddTxViewController: UIViewController {
  
    var context = EntryContext()
    
    @IBAction func addIncome(_ sender: Any) {
        context.type = .Income
        pushToNextVC()
    }
    
    @IBAction func addTransfer(_ sender: Any) {
        context.type = .Transfer
        pushToNextVC()
    }
    
    @IBAction func addExpense(_ sender: Any) {
        context.type = .Expense
        pushToNextVC()
    }
    
    private func pushToNextVC() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterAmountVC") as? EnterNumberViewController else {return}
        vc.context = context
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



