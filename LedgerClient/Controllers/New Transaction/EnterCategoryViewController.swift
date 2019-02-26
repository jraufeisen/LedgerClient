//
//  EnterCategoryViewController.swift
//  LedgerClient
//
//  Created by Johannes on 26.02.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//

import UIKit

class EnterCategoryViewController: CategoryTableViewController {
    var context = EntryContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryDelegate = self
    }
    
}

extension EnterCategoryViewController : CategoryTableViewDelegate {
    
    func didSelectCategory(category: String) {
        context.budgetCategory = category
        
        //Move on to description
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Enter_Description_VC_ID") as? EnterDescriptionViewController  else {return}
        vc.context = context
        navigationController?.pushViewController(vc, animated: true)

    }
}
