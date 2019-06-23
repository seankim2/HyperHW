//
//  AppDelegate.swift
//  HyperHW
//
//  Created by khkim2 on 18/06/2019.
//  Copyright © 2019 khkim2. All rights reserved.
//

/********************************************************************
 Declare import framework
 ********************************************************************/
import UIKit
import Reachability

/********************************************************************
 Declare Class
 ********************************************************************/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        _ = CommonComponents.init()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        stopNetCheckNoti()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        startNetCheckNoti()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
        -> UIInterfaceOrientationMask {
            return [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]
    }
    
    /********************************************************************
     Check Network Connection
     ********************************************************************/
    func startNetCheckNoti() {
        print("\(#function)")
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    func stopNetCheckNoti() {
        print("\(#function)")
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    @objc func reachabilityChanged(note: Notification) {
        if let reachability = note.object as? Reachability {
            switch reachability.connection {
            case .wifi:
                print("Reachable via WiFi")
            case .cellular:
                print("Reachable via Cellular")
            case .none:
                print("Network not reachable")
                CommonComponents.sharedInstance?.processPopup(title: "알림", message: "네트워크 연결을 확인해 주세요.")
            }
        }
    }
}
