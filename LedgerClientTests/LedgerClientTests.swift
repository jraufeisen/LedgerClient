//
//  LedgerClientTests.swift
//  LedgerClientTests
//
//  Created by Johannes on 23.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import XCTest


class LedgerClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testAccountParsing() {
        let input = """
                2017/10/08 Tanken
                    Assets:Banking:Kreditkarte      -48.27 EUR
                    [Assets:Budget:Sprit]     -48.27 EUR
                    Ausgaben:Sprit     48.27 EUR
                    Equity:AntiBudget:Sprit
        """

        let parser = Parser.init(ledgerString: input)
        
        XCTAssert(parser.accounts.contains(Account.init(name: "Assets:Banking:Kreditkarte")))
        XCTAssert(parser.accounts.contains(Account.init(name: "Assets:Budget:Sprit")))
        XCTAssert(parser.accounts.contains(Account.init(name: "Ausgaben:Sprit")))
        XCTAssert(parser.accounts.contains(Account.init(name: "Equity:AntiBudget:Sprit")))
        XCTAssert(parser.accounts.count == 4)
        
        
    }
    
    func testDateParsing() {
        var input = "2017/10/08 Tanken"
        var date = Parser.parseDateFromLine(line: input)

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        let trueDate = dateFormatter.date(from: "2017-10-08")! //according to date format your date string
        
        XCTAssert(date == trueDate)
        
        
        input = "There is no date in here"
        date = Parser.parseDateFromLine(line: input)
        XCTAssert(date == nil)
    }
    
    func testNameParsing() {
        var input = "2017/10/08 Tanken bei Tankstelle so und so"
        var name = Parser.parseNameFromLine(line: input)
        
        XCTAssert(name == "Tanken bei Tankstelle so und so")
        
        input = "There is no date in here"
        name = Parser.parseNameFromLine(line: input)
        XCTAssert(name == nil)
    }
    
    func testTransactionParsing() {
        let input = """
                2017/10/08 Tanken
                    Assets:Banking:Kreditkarte      -48.27 EUR
                    [Assets:Budget:Sprit]     -48.27 EUR
                    Ausgaben:Sprit     48.27 EUR
                    Equity:AntiBudget:Sprit
        """

        let tx = Transaction.init(ledgerString: input)!
        
        //Date
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        let trueDate = dateFormatter.date(from: "2017-10-08")! //according to date format your date string
        XCTAssert(tx.date == trueDate)
        
        //Data and equity check
        let acc = Account.init(name: "Equity:AntiBudget:Sprit")
        let val = Decimal.init(string: "48.27")!
        XCTAssert(tx.postings.contains(where: {$0.0 == acc && $0.1 == val} ))
        
    }
    
    func testMultipleTXParsing() {
        let input = """
            2017/10/12 Pizza Hut
                Assets:Banking:Bargeld      -8 EUR
                [Assets:Budget:Lebensmittel]     -8 EUR
                Ausgaben:Lebensmittel     8 EUR
                Equity:AntiBudget:Lebensmittel


            2017/10/13 Internet
                Assets:Banking:Girokonto     -30 EUR
                [Assets:Budget:Internet]         -30 EUR
                Ausgaben:Internet        30 EUR
                Equity:AntiBudget:Internet
        """
        let parser = Parser.init(ledgerString: input)
        XCTAssert(parser.transactions.count == 2)
        XCTAssert(parser.accounts.count == 8)
        print(parser.transactions)
        
        
        let pizzaTX = parser.transactions.first!
        XCTAssert(pizzaTX.name == "Pizza Hut")

        let internetTX = parser.transactions[1]
        XCTAssert(internetTX.name == "Internet")
        let acc = Account.init(name: "Equity:AntiBudget:Internet")
        let val = Decimal.init(string: "30")!
        XCTAssert(internetTX.postings.contains(where: {$0.0 == acc && $0.1 == val} ))

        
        
    }
    
    
    
    func testPostingParsing() {
        let input = "   Assets:Banking:Kreditkarte      -48.27 EUR"
        let posting = Parser.parsePostingFromLine(line: input)!
        let key = Account.init(name: "Assets:Banking:Kreditkarte")
        let val = Decimal.init(string: "-48.27")!
        XCTAssert(posting == (key,val) )
    }
    
    
    
    
    
    
    
}
