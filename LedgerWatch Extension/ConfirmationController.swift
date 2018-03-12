//
//  ConfirmationController.swift
//  LedgerClient
//
//  Created by Johannes on 12.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import WatchKit
import Foundation

class ConfirmationController: WKInterfaceController {

    @IBOutlet var confirmationLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedResult(notification:)), name: NSNotification.Name.init(rawValue: "ReceivedResultForPosting"), object: nil)

    }
    
    deinit {
        
    }
    
    @objc private func receivedResult(notification: Notification) {
        guard let success = notification.object as? Bool else {
            confirmationLabel.setText("Result unclear...")
            return
        }
        
        if success {
            confirmationLabel.setText("Done :)")
        } else {
            confirmationLabel.setText("Error!")

        }
        
        
    }
    
}
