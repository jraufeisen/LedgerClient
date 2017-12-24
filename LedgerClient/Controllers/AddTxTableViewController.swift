//
//  AddTxTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 03.10.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class AddTxTableViewController: UITableViewController, UITextFieldDelegate {
   
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var accountField: UITextField!
    
    @objc func addTransaction() {
        
        guard let value = self.valueField.text?.replacingOccurrences(of: ",", with: ".") else {return}
        guard let category = self.categoryField.text else {return}
        guard let account = self.accountField.text else {return}
        
        guard !(value.isEmpty) else {return}
        guard !(category.isEmpty) else {return}
        
        
        let reverse_value = value.range(of: "-") == nil ? "-" + value : value.replacingOccurrences(of: "-", with: "")
        
        let string_contents = LedgerManager.defaultJournal()
    
        let date = LedgerManager.dateString(date: Date())
        
        let append = """
        
        \(date) Transaktion
        \tAssets:Banking:\(account) \t \(value) EUR
        \t[Assets:Budget:\(category)]\t \(value) EUR
        \tAusgaben:\(category)\t \(reverse_value) EUR
        \tEquity:AntiBudget:\(category)
        
        """
        let together = string_contents + "\n\n" + append
        do {
            try together.write(to: LedgerManager.defaultURL(), atomically: true, encoding: String.Encoding.utf8)
            clearInputs()
        } catch {
            print("Could not write")
        }
        
        
        
        
        
    }

    func clearInputs() {
        for field in [valueField, categoryField, accountField] {
            field?.text = ""
            field?.resignFirstResponder()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(addTransaction))
        
        //MARk value red/greeen
        valueField.addTarget(self, action: #selector(markValue), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    //MARK: UITextFieldDelegate
    @objc func markValue() {
        guard var text = valueField.text else {return}
        text = text.replacingOccurrences(of: ",", with: ".")
        guard let value = Decimal.init(string: text) else {return}
        if value > 0 {
            valueField.textColor = .green
        } else if value < 0 {
            valueField.textColor = .red
        } else {
            valueField.textColor = .gray
        }

    }
    
 
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Interaction with other VC
    public func configureCategory(category: String) {
        categoryField.text = category
    }
  
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if ( indexPath.row == 2 ) {
            //Accounts selected
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "account_VC_ID") as? AccountTableViewController else {return}
            vc.accountDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

}

extension AddTxTableViewController: AccountTableViewDelegate {
    
    func didSelectAccount(account: String) {
        accountField.text = account
    }
    
}


