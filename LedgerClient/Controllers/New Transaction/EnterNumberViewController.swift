//
//  EnterNumberViewController.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class EnterNumberViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    var context = EntryContext()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonToKeyboard()
        updateBackground()
        
        
        numberTextField.becomeFirstResponder()
    }
    
    func updateBackground() {
        if context.type == .Income {
            self.view.backgroundColor = UIColor.incomeColor
        } else if context.type == .Expense {
            self.view.backgroundColor = UIColor.expenseColor
        } else if context.type == .Transfer {
            self.view.backgroundColor = UIColor.transferColor
        }
    }
    
    func addDoneButtonToKeyboard() {
        let doneButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EnterNumberViewController.hideKeyboard))
        let toolbar = UIToolbar()
        toolbar.frame.size.height = 45
        
        let space:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var items = [UIBarButtonItem]()
        items.append(space)
        items.append(doneButton)
        
        toolbar.items = items
        
        numberTextField.inputAccessoryView = toolbar
    }

    @objc func hideKeyboard() {
        context.money = numberTextField.text
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "enter_account_VC_ID") as? EnterAccountViewController else {return}
        vc.context = context
        navigationController?.pushViewController(vc, animated: true)
        numberTextField.resignFirstResponder()
    }

}
