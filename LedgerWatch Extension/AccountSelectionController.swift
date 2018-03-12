//
//  AccountSelectionController.swift
//  LedgerWatch Extension
//
//  Created by Johannes on 12.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import Foundation
import WatchKit

class AccountSelectionController: WKInterfaceController {

    @IBOutlet var summaryLabel: WKInterfaceLabel!
    @IBOutlet var accountsTable: WKInterfaceTable!
    
    var accounts = ["Bargeld", "Girokonto", "Kreditkarte", "Tagesgeld"]
    
    //Ledger data
    var context: NumberContext?
    var value: String?
    
    
    override func awake(withContext context: Any?) {
        //prepare the table view
        updateTable()
        
        //Set the sumary label's text
        guard let summary = context as? (NumberContext, String) else {return}
        self.context = summary.0
        self.value = summary.1
        
        switch summary.0 {
        case .Income:
            summaryLabel.setText("Income of \(summary.1)€")
        default:
            summaryLabel.setText("Expense of \(summary.1)€")
        }
    }
    
  
    
    ///Loads all necessary data in the tableview
    private func updateTable() {
        accountsTable.setNumberOfRows(accounts.count, withRowType: "accountRow")
        for i in 0..<accounts.count {
            if let row = accountsTable.rowController(at: i) as? AccountRow {
                row.label.setText(accounts[i])
            }
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let money = self.value else {return}
        if context == NumberContext.Income {
            //Post income statement to ledger file
            WatchSessionManager.sharedManager.sendIncomeMessage(acc: accounts[rowIndex], value: money)
            //Show confirmation screen....
            pushController(withName: "confirmationController", context: nil)
            
        } else {
            //A category must be selected for the expense
        }
        
    }
    
    
    
    
}
