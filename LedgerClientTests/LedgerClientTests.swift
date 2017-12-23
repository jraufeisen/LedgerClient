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
        print(parser.accounts)
        
        XCTAssert(parser.accounts.contains(Account.init(name: "Assets:Banking:Kreditkarte")))
        XCTAssert(parser.accounts.contains(Account.init(name: "Assets:Budget:Sprit")))
        XCTAssert(parser.accounts.contains(Account.init(name: "Ausgaben:Sprit")))
        XCTAssert(parser.accounts.contains(Account.init(name: "Equity:AntiBudget:Sprit")))
        XCTAssert(parser.accounts.count == 4)
        
        
    }
    
}
