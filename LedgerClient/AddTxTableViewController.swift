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
        
        FileManager.default.url(forUbiquityContainerIdentifier: nil)
        guard let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {return}
        let finance_URL = iCloudDocumentsURL.appendingPathComponent("/finances.txt")
        let found = FileManager.default.contents(atPath: finance_URL.path)!
        guard let string_contents = String.init(data: found, encoding: String.Encoding.utf8) else {return}
        let append = "2017/10/03 Test Transaktion\n\tAssets:Banking:Bargeld \t \(value) €\n\t[Assets:Budget:\(category)]\t \(value) €\n\tAusgaben:\(category)\t \(reverse_value) €\n\tEquity:AntiBudget:\(category)"
        let together = string_contents + "\n\n" + append
        do {
            try together.write(to: finance_URL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Could not write")
        }
        
        
        
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(addTransaction))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Interaction with other VC
    public func configureCategory(category: String) {
        self.categoryField.text = category
    }

}
