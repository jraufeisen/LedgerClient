//
//  LedgerManager.swift
//  LedgerClient
//
//  Created by Johannes on 03.10.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

class LedgerManager: NSObject {
    
    
    
    
    class func categories() -> [String] {
        
        var categories = [String]()
        
        FileManager.default.url(forUbiquityContainerIdentifier: nil)
        guard let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {return categories}
        let finance_URL = iCloudDocumentsURL.appendingPathComponent("/finances.txt")
        let found = FileManager.default.contents(atPath: finance_URL.path)!
        guard let string_contents = String.init(data: found, encoding: String.Encoding.utf8) else {return categories}

        
        let pat = "Assets:Budget:\\b([^]]*)"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: string_contents, options: [], range: NSRange(location: 0, length: string_contents.characters.count))
        
        for match in matches {
            let range = match.rangeAt(1)
            let r = string_contents.index(string_contents.startIndex, offsetBy: range.location) ..< string_contents.index(string_contents.startIndex, offsetBy: range.location+range.length)
            //testStr.substring(from: testStr.index(testStr.startIndex, offsetBy: range.location))
            let category = string_contents.substring(with: r)
            
            if (!categories.contains(category)) {
                categories.append(category)
            }
            
        }
        
        
        return categories
        
    }
    
    
}
