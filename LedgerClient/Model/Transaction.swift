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
    let postings: [Account: Decimal]
    
    init(name: String, date: Date, postings: [Account: Decimal]) {
        self.name = name
        self.date = date
        self.postings = postings
        super.init()
    }
    
    init?(ledgerString: String) {
        let cleanedLedger = ledgerString.trimmingCharacters(in: .whitespaces)
        
        guard let date = Parser.parseDateFromLine(line: cleanedLedger) else { return nil }
        self.date = date
       
        
        
        for lineSubString in cleanedLedger.split(separator: "\n").dropFirst() {
            let line = String(lineSubString)
           
        }
        
        
        self.name = ""
        self.postings = [:]
        
        super.init()
    }
    
    
    
    
    
    
    
}
