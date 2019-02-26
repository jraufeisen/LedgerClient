//
//  EnterAccountTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class EnterAccountViewController: AccountTableViewController {

    var context = EntryContext()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountDelegate = self
    }
    
}


extension EnterAccountViewController: AccountTableViewDelegate {
    func didSelectAccount(account: String) {
        //Move on to category (if expense) or description (if income)
        context.account = account
        
        if (context.type == .Expense) {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "enter_category_VC_ID") as? EnterCategoryViewController  else {return}
            vc.context = context
            navigationController?.pushViewController(vc, animated: true)
        } else if (context.type == .Income) {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Enter_Description_VC_ID") as? EnterDescriptionViewController  else {return}
            vc.context = context
            navigationController?.pushViewController(vc, animated: true)
        } else if (context.type == .Transfer) {
            //TODO: Implement transfer (this needs a second account selection)
        }
        
    }
}
