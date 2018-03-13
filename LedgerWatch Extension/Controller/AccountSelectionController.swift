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
    var context: EntryContext?
    
    override func awake(withContext context: Any?) {
        //prepare the table view
        updateTable()
        
        //Set the sumary label's text
        guard let summary = context as? EntryContext else {return}
        self.context = summary
        guard let type = summary.type else {return}
        guard let money = summary.money else {return}

        switch type {
        case .Income:
            //Attributed string, where parts of it are colored
            let income_string = NSMutableAttributedString.init(string: "Income", attributes: nil)
            income_string.append(NSAttributedString.init(string: " of ", attributes: nil))
            income_string.append(NSAttributedString.init(string: "\(money)€", attributes: [NSAttributedStringKey.foregroundColor: UIColor.green]))
        
            summaryLabel.setAttributedText(income_string)
        default:
            //Attributed string, where parts of it are colored
            let expense_string = NSMutableAttributedString.init(string: "Expense", attributes: nil)
            expense_string.append(NSAttributedString.init(string: " of ", attributes: nil))
            expense_string.append(NSAttributedString.init(string: "\(money)€", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red]))
            
            summaryLabel.setAttributedText(expense_string)
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
        guard let money = self.context?.money else {return}
        if context?.type == NumberContext.Income {
            //Ask Connection Manager to post income statement to ledger file
            WatchSessionManager.sharedManager.sendIncomeMessage(acc: accounts[rowIndex], value: money)
            //Show confirmation screen....
            pushController(withName: "confirmationController", context: nil)
            
        } else {
            //A category must be selected for the expense
            context?.account = accounts[rowIndex]
            pushController(withName: "budgetController", context: context)
        }
        
    }
    
    
    
    
}
