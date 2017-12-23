//
//  LedgerManager.swift
//  LedgerClient
//
//  Created by Johannes on 03.10.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class LedgerManager: NSObject {
    
    class func defaultURL() -> URL {
        guard let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {return URL.init(fileURLWithPath: "")}
        let finance_URL = iCloudDocumentsURL.appendingPathComponent("/finances.txt")
        return finance_URL
    }
    
    class func defaultJournal() -> String {
        let found = FileManager.default.contents(atPath: LedgerManager.defaultURL().path)!
        guard let string_contents = String.init(data: found, encoding: String.Encoding.utf8) else {return ""}
        return string_contents
    }
    
    
    
    /*
    *   Returns a string describing a date in the correct format 2016/10/05
    */
    class func dateString(date: Date) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    
    class func categories() -> [String] {
        
        var categories = [String]()
        
        let string_contents = LedgerManager.defaultJournal()
        
        let pat = "Assets:Budget:\\b([^]]*)"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: string_contents, options: [], range: NSRange(location: 0, length: string_contents.characters.count))
        
        for match in matches {
            let range = match.range(at: 1)
            let r = string_contents.index(string_contents.startIndex, offsetBy: range.location) ..< string_contents.index(string_contents.startIndex, offsetBy: range.location+range.length)

            let category = String(string_contents[r])
            if (!categories.contains(category)) {
                categories.append(category)
            }
            
        }
        
        
        return categories
        
    }
    
    
    class func availableBudget(category: String) -> Decimal {
        let pat = "Assets:Budget:\(category)]\\s*[-0-9.]*"
        let testStr = LedgerManager.defaultJournal()
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count))

        var total: Decimal = Decimal(0)
        for match in matches {
            let range = match.range(at: 0)
            var found = String(testStr[testStr.index(testStr.startIndex, offsetBy: range.location)...])
            found = found.replacingOccurrences(of: "Assets:Budget:\(category)]", with: "")
            found = found.trimmingCharacters(in: .whitespaces)
            if let value = Decimal.init(string: found) {
                total += value
            }
            
        }
        return total
        
    }
    
    class func balance(account: String) -> Decimal {
        let pat = "Assets:Banking:\(account)\\s*[-0-9.]\\s*[EUR]*"
        let testStr = LedgerManager.defaultJournal()
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count))
        var total: Decimal = Decimal(0)
        for match in matches {
            let range = match.range(at: 0)
            var found = String(testStr[testStr.index(testStr.startIndex, offsetBy: range.location)...])
            found = String.init(found.split(separator: "\n")[0])
            found = found.replacingOccurrences(of: "Assets:Banking:\(account)", with: "")

            found = found.trimmingCharacters(in: .whitespaces)
            if let value = Decimal.init(string: found) {
                total += value
            }
            
        }
        return total
    }
    
    
}
