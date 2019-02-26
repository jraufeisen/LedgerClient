//
//  WatchSessionManager.swift
//  LedgerClient
//
//  Created by Johannes on 12.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import WatchConnectivity

/**
This protocol can be used by classes that want to receive current ledger data.
Conforming to this protocl will notify you of changes in budget, accounts, ...
*/
protocol LedgerDataDelegate {
    func newBudgetDataAvailable(newBudget: [String: String]?)
}

// Note that the WCSessionDelegate must be an NSObject
// So no, you cannot use the nice Swift struct here!
class WatchSessionManager: NSObject {

    //MARK: Constants
    static let resultNotificationName = "ReceivedResultForPosting"
    static let budgetNotificationName = "ReceivedBudget"

    //MARK: Singleton
    
    // Instantiate the Singleton
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }

    //MARK: Ledger Data
    
    ///Delegate to notify of new available data (this is most often the active interface controller)
    var dataDelegate: LedgerDataDelegate?
    ///The accounts as provided by the parent iOS app. TODO: Implement
    var accounts: [String]?
    ///The budget as provided by the parent iOS app. Use askForBudget() to update this value. Best practice: Update all relevant information on app start
    var budget: [String:String]? {
        didSet { dataDelegate?.newBudgetDataAvailable(newBudget: budget) }
    }
    
    
    //MARK: Session
    
    // Keep a reference for the session,
    // which will be used later for sending / receiving data
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    // starting a session has to now deal with it being an optional
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
   
    
    
}

extension WatchSessionManager: WCSessionDelegate {
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    #endif
    
    #if os(watchOS)
    ///The watch should ask for budget and accouunts directly.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == WCSessionActivationState.activated {
            //Load intitial data, that is necessary for the app to work
            WatchSessionManager.sharedManager.askForBudget()
        } else if activationState == WCSessionActivationState.notActivated {
            //TODO ...Show communcation error screen....
            print("The SESSION COULD NOT BE ACTIVATED")
        }
        
    }
    #endif
}


//MARK: Sender
extension WatchSessionManager {
    
    ///Use this method on the Apple Wach to send a message to the phone. This message tells the iPhone to add an income statement to the ledger file.
    func sendIncomeMessage(acc: String, value: String) {
        let message = ["Income": [acc, value]]
        
        session?.sendMessage(message, replyHandler: { (response: [String: Any]) in
            //The respone block is called asynchronously
            //Expected to contain key-value pair "Success":Bool
            guard let success = response["Success"] else {
                //Result unclear
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: nil)
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: success)
        }, errorHandler: { (err: Error) in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: false)
            print("Communication-Error: Income \(err)")
        })
        
    }
    
    /**
     Use this method on the Apple Wach to send a message to the phone.
     This message tells the iPhone to add an income statement to the ledger file.
     */
    func sendExpenseMessage(acc: String, value: String, category: String) {
        let message = ["Expense": [acc, value, category]]
        
        session?.sendMessage(message, replyHandler: { (respone: [String: Any]) in
            guard let success = respone["Success"] else {return}
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: success)
        }, errorHandler: { (err: Error) in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WatchSessionManager.resultNotificationName), object: false)
            print("Communication-Error: Expense \(err)")
        })
        
    }
    
    
    /**
     Use this method to retrieve the budgeting categories from the iOS parent app.
     If successful, the budget will be stored in WatchSessionManager.sharedManager.budget. This may take an unspecified amount of time, as the call is asynchronous
     */
    func askForBudget() {
        let message = ["Ask for budget": true]
        
        session?.sendMessage(message, replyHandler: { (respone: [String: Any]) in
            guard let budget = respone["Budget"] as? [String:String] else {return}
            WatchSessionManager.sharedManager.budget = budget
        }, errorHandler: { (err: Error) in
            print("Communication-Error: Budget categories \(err)")
        })
        
        
    }
    
}


//MARK: Receiver
extension WatchSessionManager {

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //new income statement
        if let incomeArray = message["Income"] as? [String] {
            let bankingAccount = Account.init(name: "Assets:Banking:\(incomeArray[0])")
            let success = LedgerModel.shared().postIncome(acc: bankingAccount,  value: incomeArray[1])
            //Call the reply handler
            replyHandler(["Success":success])
        }
        
        //Return categories
        if message["Ask for budget"] != nil {
            let categories = LedgerModel.shared().categories()
            let budgetValues = categories.map{ LedgerModel.shared().budgetInCategory(category: $0).description}
            
            let budget = Dictionary(uniqueKeysWithValues: zip(categories, budgetValues))
            replyHandler(["Budget":budget])
        }

        //New expense statement
        if let expenseArray = message["Expense"] as? [String] {
            let success = LedgerModel.shared().postExpense(acc: expenseArray[0], value: expenseArray[1], category: expenseArray[2])
            //Call the reply handler
            replyHandler(["Success":success])
        }

        

    }
}


