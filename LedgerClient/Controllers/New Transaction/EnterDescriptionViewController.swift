//
//  EnterDescriptionViewController.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class EnterDescriptionViewController: UIViewController {
    var context = EntryContext()

    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBackground()
        descriptionTextField.becomeFirstResponder()
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
    
    

}

extension EnterDescriptionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Write tx to ledger file
        context.description = textField.text
        
        _ = LedgerModel.defaultModel.postTransaction(context: context)
        
        navigationController?.popToRootViewController(animated: true)
        return true
    }
}
