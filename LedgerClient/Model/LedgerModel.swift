//
//  LedgerModel.swift
//  LedgerClient
//
//  Created by Johannes on 24.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class LedgerModel: NSObject {

    
    private static var privateShared : LedgerModel?
    class func shared() -> LedgerModel {
        guard let uwShared = privateShared else {
            privateShared = LedgerModel.init(ledgerString: defaultJournal)
            return privateShared!
        }
        return uwShared
    }
    private func resetSharedModel() {
        LedgerModel.privateShared = nil
    }
    
    ///All accounts in the given file
    let accounts: [Account]
    
    ///All transactions that occurred
    let transactions: [Transaction]
    
    
    //MARK: Initializers
    class var defaultURL: URL {
        guard let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {print("iCloud URL not found");return URL.init(fileURLWithPath: "")}
        let finance_URL = iCloudDocumentsURL.appendingPathComponent("/finances.txt")
        return finance_URL
    }
    
    class var defaultJournal: String {
        guard let found = FileManager.default.contents(atPath: LedgerModel.defaultURL.path) else {print("Ledger file not found");return ""}
        guard let string_contents = String.init(data: found, encoding: String.Encoding.utf8) else {return ""}
        return string_contents
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

 
    
    /**
     Returns the budget for the month specified by the given date.
     A budget consists of different categories and the corresponing envelope money budgeted.
     May return nil, if there is no budget for the specified month
     
     Extra documentation: Inside the ledger file, each month's budget is labelled like "Budget 03/2018"
     */
    func budgetAtMonth(date: Date) -> [(Account,Decimal)]? {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "MM/yyyy"
        let monthString = dateFormatter.string(from: date)
        
        let budgettingTransaction = transactions.filter{ $0.name.contains("Budget \(monthString)") }
        
        return budgettingTransaction.first?.postings
    }
    
    
    //MARK: Enter new data
    
    ///Appends a new transaction to the current ledger file. Returns YES on success
    func postTransaction(context: EntryContext) -> Bool {
        
        if (context.type == .Expense) {
            guard let acc = context.account else {return false}
            guard let value = context.money else {return false}
            guard let category = context.budgetCategory else {return false}
            var description = "Transaktion"
            if let desc = context.description {
                if !desc.isEmpty {  description = desc }
            }
            
            return postExpense(acc: acc, value: value, category: category, description: description)
        } else if (context.type == .Income) {
            guard let acc = context.account else {return false}
            guard let value = context.money else {return false}
            var description = "Transaktion"
            if let desc = context.description {
                if !desc.isEmpty {  description = desc }
            }
            
            return postIncome(acc: acc, value: value, description: description)
            
        } else if (context.type == NumberContext.Transfer) {
            //TODO: Implement transfer
        }
        
        return false
    }
    
    
    ///Appends income to the current ledger file. Returns YES on success
    func postIncome(acc: String, value: String, description: String = "Transaktion") -> Bool {
        return postIncome(acc: Account.init(name: "Assets:Banking:\(acc)"), value: value, description: description)
    }
    
    ///Appends income to the current ledger file. Returns YES on success
    func postIncome(acc: Account, value: String, description: String = "Transaktion") -> Bool {
        let value = value.replacingOccurrences(of: ",", with: ".")
        guard let income = Float(value) else {print("Not a valid number");return false}
        guard income > 0 else {print("Not a positive income!");return false}
        
        let date = LedgerModel.dateString(date: Date())
        let incomeStatement = """
        
        \(date) \(description)
        \t\(acc.name) \t \(value) EUR
        \tEquity:Income
        
        """
        return appendToLedger(appendingString: incomeStatement)
        
    }
    
    
    ///Appends expense to the current ledger file. Returns YES on success
    func postExpense(acc: String, value: String, category: String, description: String = "Transaktion") -> Bool {
        let value = value.replacingOccurrences(of: ",", with: ".")
        guard let expense = Float(value) else {print("Not a valid number");return false}
        guard expense > 0 else {print("Not a positive expense!");return false}

        
        let date = LedgerModel.dateString(date: Date())
        let reverse_value = value.range(of: "-") == nil ? "-" + value : value.replacingOccurrences(of: "-", with: "")

        let expenseStatement = """
        
        \(date) \(description)
        \tAssets:Banking:\(acc) \t \(reverse_value) EUR
        \t[Assets:Budget:\(category)]\t \(reverse_value) EUR
        \tExpenses:\(category)\t \(value) EUR
        \tEquity:AntiBudget:\(category)

        """
        return appendToLedger(appendingString: expenseStatement)
        
    }

    
    
    
    
    ///Appends string to the current ledger file. Returns YES on success
    private func appendToLedger(appendingString: String) -> Bool {
        resetSharedModel()

        let together = LedgerModel.defaultJournal + "\n" + appendingString
        do {
            try together.write(to: LedgerModel.defaultURL, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            print("Could not write to ledgerFile")
            return false
        }
        
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
    
    class func beancountDateString(date: Date) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    
    //MARK: Conversion to Beancount
    
    /**
     This function creates a string in the valid beancount formula containing all the transactions and accounts from the original ledger model.
    */
    func convertToBeancount() -> String {
        
        var beancount = ""
        
        //Open all the accounts at the beginning
        for acc in accounts {
            beancount += "1970-01-01 open \(acc.name)\n"
        }
        
        
        //Add options
        beancount += "\noption \"title\" \"Auto converted ledger->beancount file\"\n"
        beancount += "option \"operating_currency\" \"EUR\"\n"

        //Add transactions
        for tx in transactions {
            
            //First line contains date and title
            beancount += "\n\n\(LedgerModel.beancountDateString(date: tx.date)) * \"\(tx.name)\""
            
            //Following lines include inteded postings
            for (acc, value) in tx.postings {
                beancount += "\n\t\(acc.name) \(value) EUR"
            }
            
        }
        return beancount
    }
}
