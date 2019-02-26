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

    }
    
    
    
    

}

extension EnterDescriptionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Write tx to ledger file
        context.description = textField.text
        
        print(context)
        
        
        _ = LedgerModel.defaultModel.postTransaction(context: context)
        
        
        
        
        navigationController?.popToRootViewController(animated: true)
        return true
    }
}
