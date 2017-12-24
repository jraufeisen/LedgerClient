//
//  LedgerModel.swift
//  LedgerClient
//
//  Created by Johannes on 24.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class LedgerModel: NSObject {

    
    //All accounts in the given file
    let accounts: [Account]
    
    //All transactions that occurred
    let transactions: [Transaction]

    
    //MARK: Initializers
    class var defaultURL: URL {
        guard let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {return URL.init(fileURLWithPath: "")}
        let finance_URL = iCloudDocumentsURL.appendingPathComponent("/finances.txt")
        return finance_URL
    }
    
    class var defaultJournal: String {
        let found = FileManager.default.contents(atPath: LedgerManager.defaultURL().path)!
        guard let string_contents = String.init(data: found, encoding: String.Encoding.utf8) else {return ""}
        return string_contents
    }
    
    class func defaultModel() -> LedgerModel {
        return LedgerModel.init(ledgerString: defaultJournal)
    }
    
    init(ledgerString: String) {
        self.accounts = Parser.parseAccounts(ledgerString: ledgerString)
        self.transactions = Parser.parseTransactions(ledgerString: ledgerString)
        super.init()
    }
    
    //MARK: Calculations
    

    /*
     *   After having parsed all relevant information this method calculates the overall balance of an account
     */
    func balanceForAccount(acc: Account) -> Decimal {
        var sum: Decimal = 0
        for tx in transactions {
            sum += tx.valueForAccount(acc: acc)
        }
        return sum
        
    }
    
}
