//
//  Utility.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit

class Utility {
    
     static let util = Utility()
     private  init() {}
    
    func createHttpBody(sharingDictionary : NSMutableDictionary) -> Data
    {
        let parameterArray : NSMutableArray = []
        for keyValue in sharingDictionary.allKeys
        {
            let keyString = "\(keyValue)=\(sharingDictionary[keyValue]!)"
            parameterArray.add(keyString)
        }
        var postString = String()
        postString = parameterArray.componentsJoined(by: "&")
        print(postString)
        return postString.data(using: .utf8)!
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    // MARK : Show alert
    func topMostViewController(rootViewController: UIViewController) -> UIViewController? {
        if let navigationController = rootViewController as? UINavigationController {
            return topMostViewController(rootViewController: navigationController.visibleViewController!)
        }
        if let tabBarController = rootViewController as? UITabBarController {
            if let selectedTabBarController = tabBarController.selectedViewController {
                return topMostViewController(rootViewController: selectedTabBarController)
            }
        }
        if let presentedViewController = rootViewController.presentedViewController {
            return topMostViewController(rootViewController: presentedViewController)
        }
        return rootViewController
    }
    
    func rootViewController() -> UIViewController {
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
    
    func alertController(controller:UIViewController? = nil,title:String, message:String,okButtonTitle:String,completionHandler:@escaping (_ index: NSInteger) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            completionHandler(0)
        }))
        let topViewController: UIViewController? = topMostViewController(rootViewController: rootViewController())
        topViewController?.present(alert, animated: true, completion: nil)
        
    }

}
