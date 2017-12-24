//
//  AccountTableViewController.swift
//  LedgerClient
//
//  Created by Johannes on 05.10.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {

    let model = LedgerModel.defaultModel()
    let accounts = ["Bargeld","Girokonto","Kreditkarte", "Tagesgeld"]
    var accountDelegate: AccountTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Accounts"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Use account delegate to let other VC know which account has been selected
        accountDelegate?.didSelectAccount(account: accounts[indexPath.row])
        navigationController?.popViewController(animated: true)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") else {return UITableViewCell()}
        let account = Account.init(name: "Assets:Banking:\(accounts[indexPath.row])")
        
        
        cell.textLabel?.text = accounts[indexPath.row]
        cell.detailTextLabel?.text = "\(model.balanceForAccount(acc: account))"
        
        return cell
    }
}

protocol AccountTableViewDelegate {
    func didSelectAccount(account: String)
}


