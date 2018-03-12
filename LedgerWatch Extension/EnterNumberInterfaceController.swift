//
//  EnterNumberInterfaceController.swift
//  LedgerClient
//
//  Created by Johannes on 12.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import Foundation
import WatchKit

public enum NumberContext {
    case Expense
    case Income
}


class EnterNumberInterfaceController: WKInterfaceController {

    @IBOutlet weak var numberLabel: WKInterfaceLabel!
    @IBOutlet var confirmButton: WKInterfaceButton!
    
    ///Stores the digits that are displayed on screen. May include a comma.
    private var digits: [String] = ["0"]
    private var activeIndex = 0
    private var context: NumberContext?
    
    override func awake(withContext context: Any?) {
        guard let con = context as? NumberContext else {return}
        self.context = con
        switch con {
        case .Expense:
            numberLabel.setTextColor(UIColor.red)
        default:
            numberLabel.setTextColor(UIColor.green)
        }
        
    }
    
    
    //MARK: Update Interface
    
    ///Updates the number label according to the digit array
    private func updateLabel() {
        numberLabel.setText(digits.joined() + " €")
    }
    
    

    
    
    //MARK: Gestures
    
    /**
     Increases the digit at the current index by 1. If 10 is reached, it starts again at 0
    */
    @IBAction func recognizedTap(_ sender: Any) {
        guard let number = Int(digits[activeIndex]) else {return}
        let newNumber = (number + 1) % 10
        digits[activeIndex] = "\(newNumber)"
        updateLabel()
    }
    
    ///Create a new digit at the right and move the active index one further to the right
    @IBAction func swipedRight(_ sender: Any) {
        digits.append("0")
        activeIndex += 1
        updateLabel()
    }
    
    ///Remove the last digit
    @IBAction func swipedLeft(_ sender: Any) {
        guard digits.count > 1 else {return}
        
        digits.removeLast()
        activeIndex -= 1
        
        updateLabel()
    
    }
    
    
    ///Enter a comma and a zero afterwards
    @IBAction func swipedDown(_ sender: Any) {
        //Can only contain one comma
        guard !digits.contains(",") else {return}
        
        digits.append(",")
        digits.append("0")
        activeIndex += 2
        updateLabel()
        
        
    }
    
    
    @IBAction func swipedUp(_ sender: Any) {
        guard let con = context else {return}
        
        let valueString = digits.joined()
        pushController(withName: "accountSelection", context: (con, valueString))
        
    }
    
    @IBAction func confirmNumber() {
    }
}
