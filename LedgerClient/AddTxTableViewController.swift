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
    
    func addTransaction() {
        
        guard let value = self.valueField.text?.replacingOccurrences(of: ",", with: ".") else {return}
        guard let category = self.categoryField.text else {return}
        
        guard !(value.isEmpty) else {return}
        guard !(category.isEmpty) else {return}
        
        
        let reverse_value = value.range(of: "-") == nil ? "-" + value : value.replacingOccurrences(of: "-", with: "")
        
        let string_contents = LedgerManager.defaultJournal()
    
        let date = LedgerManager.dateString(date: Date())
        
        let append = "\(date) Test Transaktion\n\tAssets:Banking:Bargeld \t \(value) EUR\n\t[Assets:Budget:\(category)]\t \(value) EUR\n\tAusgaben:\(category)\t \(reverse_value) EUR\n\tEquity:AntiBudget:\(category)"
        let together = string_contents + "\n\n" + append
        do {
            try together.write(to: LedgerManager.defaultURL(), atomically: true, encoding: String.Encoding.utf8)
            clearInputs()
        } catch {
            print("Could not write")
        }
        
        
        
        
        
    }

    func clearInputs() {
        for field in [valueField, categoryField] {
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
        self.categoryField.text = category
    }

}
