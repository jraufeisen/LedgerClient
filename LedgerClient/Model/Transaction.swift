//
//  Transaction.swift
//  LedgerClient
//
//  Created by Johannes on 23.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

/*
 One transaction is the parsed content of e.g.
 
 2017/10/08 Tanken
    Assets:Banking:Kreditkarte -48.27 EUR
    [Assets:Budget:Sprit]      -48.27 EUR
    Ausgaben:Sprit              48.27 EUR
    Equity:AntiBudget:Sprit


 Name
 Date
 Postings to different accounts
 
 */

class Transaction: NSObject {

    let name: String
    let date: Date
    let postings: [ (Account,Decimal) ]
    
    init(name: String, date: Date, postings: [ (Account, Decimal) ]) {
        self.name = name
        self.date = date
        self.postings = postings
        super.init()
    }
    
    init?(ledgerString: String) {
        let cleanedLedger = ledgerString.trimmingCharacters(in: .whitespaces)
        
        guard let date = Parser.parseDateFromLine(line: cleanedLedger) else { return nil }
        self.date = date
       
        
        var postings = [(Account, Decimal)]()
        var equityAccount: Account? = nil
        var equitySum: Decimal = 0
        for lineSubString in cleanedLedger.split(separator: "\n").dropFirst() {
            let line = String(lineSubString)
            if let (acc, val) = Parser.parsePostingFromLine(line: line) {
                if val == Decimal.nan {
                    //Set equity account
                    guard equityAccount == nil else {return nil}
                    equityAccount = acc
                } else {
                    //Append dictionary
                    postings.append((acc, val))
                    equitySum -= val
                }
                
            }
        }
        
        //After having parsed all postings, calulate the sum for the equity posting (there must not be more than two postings with empty value)
        if let eqAcc = equityAccount {
            postings.append( (eqAcc, equitySum) )
        } else if equitySum != 0 {
            print("Warning: There is an unbalanced transaction \(equitySum). Ignoring it...")
            return nil
        }
        
        self.name = ""
        self.postings = postings
        
        super.init()
    }
    
    
    
    
    
    
    
}
