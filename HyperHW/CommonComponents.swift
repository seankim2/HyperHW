//
//  CommonComponents.swift
//  HyperHW
//
//  Created by khkim2 on 18/06/2019.
//  Copyright © 2019 khkim2. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let red = Float((hex >> 16) & 0xFF)
        let green = Float((hex >> 8) & 0xFF)
        let blue = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: CGFloat(alpha))
    }
}

class CommonComponents {
    var activityIndicatorAlert: UIAlertController?
    var popupAlertController: UIAlertController?
    let titleColor: UIColor = UIColor.colorWithRGBHex(hex: 0xF75421)
    
    static var timeSlideValue: Float = 1.0
    static var sharedInstance: CommonComponents? = nil
    
    init() {
        CommonComponents.sharedInstance = self
    }

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
}
