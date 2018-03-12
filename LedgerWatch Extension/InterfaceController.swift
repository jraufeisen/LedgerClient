//
//  InterfaceController.swift
//  LedgerWatch Extension
//
//  Created by Johannes on 11.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import WatchKit
import Foundation


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
        pushController(withName: "enterNumber", context: NumberContext.Income)
    }
    
    @IBAction func createNewExpense() {
        pushController(withName: "enterNumber", context: NumberContext.Expense)
    }
}
