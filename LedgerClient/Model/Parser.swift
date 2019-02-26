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

    /*
    *   Given the contents of a ledger file, this method parses all implicitly declared accounts
    *   May be combined with parseTransactions() to be faster.
    *   But for now, this should suffice
    */
    class func parseAccounts(ledgerString: String) -> [Account] {
        var accountSet = [Account]()
        let lines = ledgerString.split(separator: "\n")

        for i in 0..<lines.count {
            let line = String(lines[i]).trimmingCharacters(in: .whitespaces)
            guard !line.isEmpty else {continue}; //Add this line to make sure, that a first character exists. Problems can occur after custom file editing, when a line contains only whitespaces
            
            
            let firstCharacter = line[...line.index(line.startIndex, offsetBy: 0)]
            
            if Int(firstCharacter) == nil {
                //If a line does not start with a number, it will contain an account
                //This line contains an implicit declaration of an account
                if let account = Account.init(fromline: line) {
                    guard !accountSet.contains(account) else {continue}
                    accountSet.append(account)
                    
                }
            }
        }
        return accountSet
    }
    
    /*
     *   Given the contents of a ledger file, this method parses all transactions
     */
    class func parseTransactions(ledgerString: String) -> [Transaction] {
        let lines = ledgerString.split(separator: "\n")
        var tx = [Transaction]()

        var txBlockStart: Int? = nil
        for i in 0..<lines.count {
            let line = String(lines[i]).trimmingCharacters(in: .whitespaces)
            guard !line.isEmpty else {continue}; //Add this line to make sure, that a first character exists. Problems can occur after custom file editing, when a line contains only whitespaces

            let firstCharacter = line[...line.index(line.startIndex, offsetBy: 0)]
            if Int(firstCharacter) != nil {
                //This line contains a digit in the beginning and thus marks the start of a new transaction
                if (txBlockStart == nil) {
                    txBlockStart = i
                } else {
                    let transactionString = lines[txBlockStart!..<i].joined(separator: "\n")
                    if let single_tx = Transaction.init(ledgerString: transactionString) {
                        tx.append(single_tx)
                    }
                    txBlockStart = i
                }
            }
            
        }
        
        //The last transaction is not bounded below by any new date. So check it manually
        guard let txStart = txBlockStart else {return tx}
        let transactionString = lines[txStart...].joined(separator: "\n")
        if let single_tx = Transaction.init(ledgerString: transactionString) {
            tx.append(single_tx)
        }

        //Reverse order, so that the most recent transactions are the first elements
        return tx.reversed()
    }
    
    
   
    
    
    
    //MARK: Parsing
    
    
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

        //Convert to Date
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy/MM/dd" //Your date format
        guard let trueDate = dateFormatter.date(from: found) else {return nil}//according to date format your date string
            
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
        var testStr = line.trimmingCharacters(in: .whitespaces)
        testStr = String(testStr.split(separator: "\n").first!).trimmingCharacters(in: .whitespacesAndNewlines)
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
