//
//  UIApplicationExtension.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 6/5/22.
//

import UIKit

extension UIApplication {
    class func getPresentedViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var viewController: UIViewController?
        
        if keyWindow != nil {
            if var topController = keyWindow!.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                viewController = topController
            }
        }
        return viewController
    }
}
