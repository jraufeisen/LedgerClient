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
    
    /*
    * Scans a line to find a date at the beginning
    * e.g.  2017/10/08 Tanken
    */
    class func parseDateFromLine(line: String) -> Date? {
        //Ignore leading (and trailing) whitespaces
        let testStr = line.trimmingCharacters(in: .whitespaces)
        //Match until an invalid character occurrs
        let pat = "[0-9,/]*"
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
    class func parsePostingFromLine(line: String) -> [Account: Decimal]? {
        let testStr = line.trimmingCharacters(in: .whitespaces)
        
        guard let account = Account.init(fromline: testStr) else {return nil}
    
        //Scan for value
        let pat = "[0-9,.,-]+"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count))
        guard let match = matches.first else { return nil}
        let range = match.range(at: 0)
        let startIndex = testStr.index(testStr.startIndex, offsetBy: range.location)
        let endIndex = testStr.index(testStr.startIndex, offsetBy: range.location+range.length)
        let found = String(testStr[startIndex..<endIndex])

        guard let value = Decimal.init(string: found) else {return nil}
        
        return [account:value]
    }
    
    
}
