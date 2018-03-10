//
//  TransactionTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 22.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class TransferTableViewController: UITableViewController {

    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var fromAccount: UILabel!
    @IBOutlet weak var toAccount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(addTransfer))
        amount.addTarget(self, action: #selector(markValue), for: .editingChanged)


    }

  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ( indexPath.row >= 1 ) {
            //From or To account selected
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "account_VC_ID") as? AccountTableViewController else {return}
            vc.accountDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }        
    }

}

//MARK: UI interaction
extension TransferTableViewController {
    
    @objc func addTransfer() {
        
        guard let value = self.amount.text?.replacingOccurrences(of: ",", with: ".") else {return}
        guard let from = self.fromAccount.text else {return}
        guard let to = self.toAccount.text else {return}
        
        guard !(value.isEmpty) else {return}
        guard !(from.isEmpty) else {return}
        guard !(to.isEmpty) else {return}

        
        let string_contents = LedgerModel.defaultJournal
        let date = LedgerModel.dateString(date: Date())
        let append = """
        
        \(date) Transfer
        \tAssets:Banking:\(from) \t -\(value) EUR
        \tAssets:Banking:\(to) \t \(value) EUR

        """
        let together = string_contents + "\n\n" + append
        do {
            try together.write(to: LedgerModel.defaultURL, atomically: true, encoding: String.Encoding.utf8)
            clearInputs()
        } catch {
            print("Could not write")
        }
        
    }
    
    func clearInputs() {
        amount.text = ""
        amount.resignFirstResponder()
        for field in [ fromAccount, toAccount] {
            field?.text = ""
            field?.resignFirstResponder()
        }
    }
    
    
   
    
    
}


extension TransferTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    * Changes the textcolor depending on the input
    */
    @objc func markValue() {
        guard let text = amount.text else {return}
        if isValidValue(valueString: text) {
            amount.textColor = .green
        } else {
            amount.textColor = .gray
        }

    }
    
    
    /*
    * Only positive transfer amounts are allowed.
    */
    func isValidValue(valueString: String) -> Bool {
        var text = valueString
        text = text.replacingOccurrences(of: ",", with: ".")
        guard let value = Decimal.init(string: text) else {return false}

        return value > 0
    }
}



extension TransferTableViewController: AccountTableViewDelegate {
    
    func didSelectAccount(account: String) {

        if ( tableView.indexPathForSelectedRow?.row == 1) {
            fromAccount.text = account
        } else {
            toAccount.text = account
        }
    }
    
}
