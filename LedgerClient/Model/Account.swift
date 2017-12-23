//
//  Account.swift
//  LedgerClient
//
//  Created by Johannes on 23.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit


class Account: NSObject {

    //An account only has a name atm
    let name: String
    
    override var description: String {
        return "Account: \(name)"
    }
    
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    /*
     Given a line of text from the ledger file
     e.g.     Assets:Banking:Kreditkarte -48.27 EUR
     implicitly infers the existence of an account named Assets:Banking:Kreditkarte
    */
    init?(fromline line: String) {
        //Ignore leading (and trailing) whitespaces
        var testStr = line.trimmingCharacters(in: .whitespaces)
        
        //Ignore brackets (used for virtual transactions)
        testStr = testStr.replacingOccurrences(of: "[", with: "")
        testStr = testStr.replacingOccurrences(of: "]", with: "")

        //Match until an invalid character occurrs
        let pat = "[A-Z,a-z,:]*"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count))
        guard let match = matches.first else { return nil}
        let range = match.range(at: 0)
        let startIndex = testStr.index(testStr.startIndex, offsetBy: range.location)
        let endIndex = testStr.index(testStr.startIndex, offsetBy: range.location+range.length)
        let found = String(testStr[startIndex..<endIndex])

        
        self.name = found
        super.init()
    }
}

//MARK: Compare equal
extension Account{
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Account else {return false}
        return self.name == other.name
    }
    
    
    
    
}

