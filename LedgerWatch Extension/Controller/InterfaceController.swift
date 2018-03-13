//
//  InterfaceController.swift
//  LedgerWatch Extension
//
//  Created by Johannes on 11.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import WatchKit
import Foundation


///The two possible cases for an entry: Income and Expense
public enum NumberContext {
    case Expense
    case Income
}


///This struct will be used to pass relevant context information to upfollowing interface controllers
public struct EntryContext {
    var type: NumberContext?
    var money: String?
    var account: String?
    var budgetCategory: String?
    
    init(type: NumberContext? = nil, money: String? = nil, account: String? = nil, budgetCategory: String? = nil) {
        self.type = type
        self.money = money
        self.account = account
        self.budgetCategory = budgetCategory
    }
}


class InterfaceController: WKInterfaceController {

    @IBOutlet var categoriesTableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        //Start communication session
        WatchSessionManager.sharedManager.startSession()


    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func createNewIncome() {
        pushController(withName: "enterNumber", context: EntryContext.init(type: .Income, money: nil, account: nil, budgetCategory: nil))
    }
    
    @IBAction func createNewExpense() {
        pushController(withName: "enterNumber", context: EntryContext.init(type: .Expense, money: nil, account: nil, budgetCategory: nil))
    }
}
