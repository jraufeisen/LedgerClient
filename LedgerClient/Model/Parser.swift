//
//  Parser.swift
//  LedgerClient
//
//  Created by Johannes on 23.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit


/*
 Given a ledger file this class extracts all relevant information
 */

class Parser: NSObject {

    //All accounts in the given file
    let accounts: [Account]
    
    //All transactions that occurred
    let transactions: [Transaction]
    
    
    init(ledgerString: String) {
        
        var accountSet = Set<Account>()
        
        //Analyze each line for its own
        for lineSubString in ledgerString.split(separator: "\n") {
            let line = String(lineSubString).trimmingCharacters(in: .whitespaces)
            
            //If a line does not start with a number, it will contain an account
            let firstCharacter = line[...line.index(line.startIndex, offsetBy: 0)]
            if Int(firstCharacter) == nil {
                //This line contains an implicit declaration of an account
                if let account = Account.init(fromline: line) { accountSet.insert(account) }
            }
        }
        
        
        self.accounts = Array.init(accountSet)
        self.transactions = []

        
        super.init()
    }
    
}
