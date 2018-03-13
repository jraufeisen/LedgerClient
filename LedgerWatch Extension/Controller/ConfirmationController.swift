//
//  ConfirmationController.swift
//  LedgerClient
//
//  Created by Johannes on 12.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import WatchKit
import Foundation

/**
 This controller shows a success or failure screen.
 It is used for both (income and expense) types of transaction.
 */
class ConfirmationController: WKInterfaceController {

    @IBOutlet var confirmationLabel: WKInterfaceLabel!
    @IBOutlet var confirmationImage: WKInterfaceImage!
    @IBOutlet var tapRecognizer: WKTapGestureRecognizer!
    
    override func awake(withContext context: Any?) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedResult(notification:)), name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: nil)
        confirmationImage.startAnimatingWithImages(in: NSRange(location: 0, length: 100), duration: 1.3, repeatCount: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: nil)
    }
    
    @objc private func receivedResult(notification: Notification) {
        tapRecognizer.isEnabled = true
        confirmationImage.stopAnimating()
        guard let success = notification.object as? Bool else {
            confirmationLabel.setText("Result unclear...")
            confirmationImage.setImageNamed("Failure")
            return
        }
        
        if success {
            confirmationLabel.setText("")
            confirmationImage.setImageNamed("Success")
            
        } else {
            confirmationLabel.setText("Error!")
            confirmationImage.setImageNamed("Failure")


        }
        
        
    }
    
    @IBAction func recognizedTap(_ sender: Any) {
        popToRootController()
    }
    
}
