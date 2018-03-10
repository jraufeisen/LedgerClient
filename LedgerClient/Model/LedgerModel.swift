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
        let found = FileManager.default.contents(atPath: LedgerModel.defaultURL.path)!
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
    
    //MARK: Extract information
    
    ///Returns all category names for the budget
    func categories() -> [String] {
        
        var categories = [String]()
        
        for account in accounts {
            let accountName = account.name
            if accountName.contains("Assets:Budget:") { categories.append(accountName.replacingOccurrences(of: "Assets:Budget:", with: "")) }
        }
        
        return categories
        
    }

    
    
    
    
    
    
    //MARK: Calculations
    /*
     *   After having parsed all relevant information this method calculates the budget in one specific category.
     */
    func budgetInCategory(category: String) -> Decimal {
        return balanceForAccount(acc: Account.init(name: "Assets:Budget:\(category)"))
    }


    /*
     *   After having parsed all relevant information this method calculates the overall balance of an account
     */
    func balanceForAccount(acc: Account) -> Decimal {
        var sum: Decimal = 0
        for tx in transactions { sum += tx.valueForAccount(acc: acc)  }
        return sum
    }
    
    /*
    *   Calculates the balance regarding all transactions that occured not later than the given date
    */
    func balanceUpToDate(acc:Account, date: Date) -> Decimal {
        var sum: Decimal = 0
        for tx in transactions {
            if tx.date <= date { sum += tx.valueForAccount(acc: acc) }
        }
        return sum
    }
    
    /*
     *   Calculates the balance regarding all transactions that occured not earlier than the given date
     */
    func balanceSinceDate(acc:Account, date: Date) -> Decimal {
        var sum: Decimal = 0
        for tx in transactions {
            if tx.date >= date { sum += tx.valueForAccount(acc: acc) }
        }
        return sum
    }
    
    //MARK: Formatting helper functions
    
    /**
     Returns a string describing a date in the correct format (e.g. 2016/10/05).
    */
    class func dateString(date: Date) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    
}
