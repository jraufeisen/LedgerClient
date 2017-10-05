//
//  AccountTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 05.10.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Accounts"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let names = ["Bargeld","Girokonto","Kreditkarte"]
        if let controller = navigationController?.viewControllers.first as? AddTxTableViewController {
            controller.configureAccount(account: names[indexPath.row])
        }
        
        navigationController?.popViewController(animated: true)

        
    }

}
