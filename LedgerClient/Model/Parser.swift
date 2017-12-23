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
        var tx = [Transaction]()
        
        let lines = ledgerString.split(separator: "\n")
        //Marks from which line to which line there is a transaction block. Transaction blocks are marked by dates
        var txBlockStart: Int? = nil
        //Analyze each line for its own
        for i in 0..<lines.count {
            let line = String(lines[i]).trimmingCharacters(in: .whitespaces)
            
            //If a line does not start with a number, it will contain an account
            let firstCharacter = line[...line.index(line.startIndex, offsetBy: 0)]
            if Int(firstCharacter) == nil {
                //This line contains an implicit declaration of an account
                if let account = Account.init(fromline: line) { accountSet.insert(account) }
            } else {
                //This line contains a digit in the beginning and thus marks the start of a new transaction
                if (txBlockStart == nil) {
                    txBlockStart = i
                } else {
                    let transactionString = lines[txBlockStart!..<i].joined(separator: "\n")
                    guard let single_tx = Transaction.init(ledgerString: transactionString) else {continue}
                    tx.append(single_tx)
                    txBlockStart = i
                }
            
                
            }
        
        }
        
        
        self.accounts = Array.init(accountSet)
        self.transactions = tx

        
        super.init()
    }
    
    /*
    * Scans a line to find a date at the beginning
    * e.g.  2017/10/08 Tanken
    */
    class func parseDateFromLine(line: String) -> Date? {
        //Ignore leading (and trailing) whitespaces
        let testStr = line.trimmingCharacters(in: .whitespaces)
        //Match until an invalid character occurrs
        let pat = "[0-9,/]+"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count))
        guard let match = matches.first else { return nil}
        let range = match.range(at: 0)
        let startIndex = testStr.index(testStr.startIndex, offsetBy: range.location)
        let endIndex = testStr.index(testStr.startIndex, offsetBy: range.location+range.length)
        let found = String(testStr[startIndex..<endIndex])

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/mm/dd" //Your date format
        let trueDate = dateFormatter.date(from: found) //according to date format your date string

        return trueDate
    }
    
    
    /*
     * Scans a line to find a correctly formatted posting
     * e.g. Assets:Banking:Kreditkarte -48.27 EUR
     */
    class func parsePostingFromLine(line: String) ->  (Account,Decimal)? {
        let testStr = line.trimmingCharacters(in: .whitespaces)

        guard let account = Account.init(fromline: testStr) else {return nil}
    
        //Scan for value
        let pat = "[0-9,.,-]+"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count))
        guard let match = matches.first else { return (account, Decimal.nan)}
        let range = match.range(at: 0)
        let startIndex = testStr.index(testStr.startIndex, offsetBy: range.location)
        let endIndex = testStr.index(testStr.startIndex, offsetBy: range.location+range.length)
        let found = String(testStr[startIndex..<endIndex])

        if let value = Decimal.init(string: found) {
            return (account,value)
        } else {
            //Indicating that this is the equity posting
            return (account, Decimal.nan)
        }
    }
    
    /*
     * Scans a line to find the name of a transactions after the date
     * e.g.  2017/10/08 Tanken
    */
    class func parseNameFromLine(line: String) -> String? {
        //Ignore leading (and trailing) whitespaces
        let testStr = line.trimmingCharacters(in: .whitespaces)
        //Match until an invalid character occurrs
        let pat = "[0-9,/]+"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count))
        guard let match = matches.first else { return nil}
        let range = match.range(at: 0)
        let endIndex = testStr.index(testStr.startIndex, offsetBy: range.location+range.length)
        let found = String(testStr[endIndex...])
        

        return found.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    
}
