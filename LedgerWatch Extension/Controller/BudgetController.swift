//
//  BudgetController.swift
//  LedgerWatch Extension
//
//  Created by Johannes on 13.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import WatchKit
import Foundation

class BudgetController: WKInterfaceController {

    @IBOutlet var budgetTable: WKInterfaceTable!
    

    var context: EntryContext?
    var categories: [String]?
    var budget: [String:String]?
    
    override func awake(withContext context: Any?) {
        WatchSessionManager.sharedManager.askForBudget()
        WatchSessionManager.sharedManager.dataDelegate = self
        guard let summary = context as? EntryContext else {return}
        self.context = summary
        
        updateTable()
    }
 
   
    
    ///Loads all necessary data in the tableview
    @objc private func updateTable() {
        
        guard let budget = WatchSessionManager.sharedManager.budget else {print("No budget loaded at this time");return}
        //Only update, when there are changes
        if let oldBudget = self.budget {
            guard budget != oldBudget else {print("I just received the same budget again");return}
        }
        
        //Update to new values
        self.categories = budget.keys.sorted()
        self.budget = budget

        
        budgetTable.setNumberOfRows(budget.count, withRowType: "budgetRow")
        for i in 0..<categories!.count {
            if let row = budgetTable.rowController(at: i) as? BudgetRow {
                let currentCategory = categories![i]
                row.categoryLabel.setText(currentCategory)
                row.moneyLabel.setText(budget[currentCategory])
                
            }
        }
        

        
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        guard context?.type == .Expense else {return}
        guard let money = context?.money else {return}
        guard let account = context?.account else {return}
        guard let categories = self.categories else {return}
        guard categories.count > rowIndex else {return}
        let category = categories[rowIndex]

        
        //Ask Connection Manager to post income statement to ledger file
        WatchSessionManager.sharedManager.sendExpenseMessage(acc: account, value: money, category: category)
        //Show confirmation screen....
        pushController(withName: "confirmationController", context: nil)
    }
    
}


//MARK: Ledger data delegate
extension BudgetController: LedgerDataDelegate {
    func newBudgetDataAvailable(newBudget: [String : String]?) {
        DispatchQueue.main.async {
            self.animate(withDuration: 0.35)  {
                self.updateTable()
            }
        }
        
    }
}

