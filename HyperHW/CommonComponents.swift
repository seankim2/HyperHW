//
//  CommonComponents.swift
//  HyperHW
//
//  Created by khkim2 on 18/06/2019.
//  Copyright © 2019 khkim2. All rights reserved.
//

/********************************************************************
 Declare import framework
 ********************************************************************/
import Foundation
import UIKit
import Reachability

/********************************************************************
 UIColor extention
 ********************************************************************/
extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let red = Float((hex >> 16) & 0xFF)
        let green = Float((hex >> 8) & 0xFF)
        let blue = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: CGFloat(alpha))
    }
}

/********************************************************************
 Declare Class
 ********************************************************************/
class CommonComponents {
    let reachability = Reachability()!
    var activityIndicatorAlert: UIAlertController?
    var popupAlertController: UIAlertController?
    let titleColor: UIColor = UIColor.colorWithRGBHex(hex: 0xF75421)
    
    static var timeSlideValue: Float = 1.0
    static var sharedInstance: CommonComponents? = nil
    
    init() {
        CommonComponents.sharedInstance = self
    }

    /********************************************************************
     * Name           : processPopup
     * Description    : process popup alert controller
     * Arguments      : title, message for alert contents
     * Returns        : Void
     ********************************************************************/
    func processPopup(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            if self.popupAlertController == nil {
                self.popupAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                self.popupAlertController!.addAction(UIAlertAction.init(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                    self.popupAlertController = nil
                }))
                
                var topController = UIApplication.shared.keyWindow?.rootViewController
                if topController != nil {
                    while let presentedViewController = topController?.presentedViewController {
                        topController = presentedViewController
                    }
                }
                
                topController!.present(self.popupAlertController!, animated: false, completion: {
                })
            }
        })
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
