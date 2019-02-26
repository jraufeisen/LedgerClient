//
//  AppDelegate.swift
//  LedgerClient
//
//  Created by Johannes on 03.10.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?

    var wcSession: WCSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //Communication with watch app
        WatchSessionManager.sharedManager.startSession()
        
        //print(LedgerModel.defaultModel.convertToBeancount())
        UITabBar.appearance().tintColor = .black

        
        
        return true
    }

  
    
}

