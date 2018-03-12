//
//  WatchSessionManager.swift
//  LedgerClient
//
//  Created by Johannes on 12.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import WatchConnectivity




// Note that the WCSessionDelegate must be an NSObject
// So no, you cannot use the nice Swift struct here!
class WatchSessionManager: NSObject {

    static let resultNotificationName = "ReceivedResultForPosting"

    // Instantiate the Singleton
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    // Keep a reference for the session,
    // which will be used later for sending / receiving data
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    // starting a session has to now deal with it being an optional
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    ///Use this method on the Apple Wach to send a message to the phone. This message tells the iPhone to add an income statement to the ledger file.
    func sendIncomeMessage(acc: String, value: String) {
        let message = ["income": [acc, value]]
        
        session?.sendMessage(message, replyHandler: { (respone: [String: Any]) in
            //The respone block is called asynchronously
            //Expected to contain key-value pair "Success":Bool
            guard let success = respone["Success"] else {return}
            print("I am the watch and I can tell you: \(success)")
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: success)
        }, errorHandler: { (err: Error) in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: false)
            print("Could not communicate with phone \(err)")
        })
        
    }

    
}

extension WatchSessionManager: WCSessionDelegate {
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}

//MARK: Receiver
extension WatchSessionManager {

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let incomeArray = message["income"] as? [String] {
            let account = Account.init(name: "Assets:Banking:\(incomeArray[0])")
            let success = LedgerModel.defaultModel().postIncome(acc: account,  value: incomeArray[1])
            //Call the reply handler
            replyHandler(["Success":success])
        }

    }
}




