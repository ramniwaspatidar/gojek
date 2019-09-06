//
//  NetworkManager.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    static let shared = NetworkManager()
     private override init() { // need to make private for singletone class
        
    }
    
    //MARK: Post request with json data method
    func postRequest(_ url: URL, params: NSMutableDictionary, completionHandler:@escaping (_ response: NSDictionary) -> Void) {
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let httpData = Utility.util.createHttpBody(sharingDictionary: params)
        urlRequest.httpBody = httpData

        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {(data, response, error) in
            
            if error != nil {
                print("Error occurred: "+(error?.localizedDescription)!)
                return;
            }
            
            do {
                let responseObjc = try (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary) as Dictionary
                    completionHandler(responseObjc as NSDictionary)
            }
            catch {
                print("Error occurred parsing data: \(error.localizedDescription)")
                return;
            }
        })
        
        task.resume()
    }


//MARK: getRequest request method

func getRequest(_ url: URL, completionHandler:@escaping (_ response: NSArray) -> Void) {
    
    let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
    let session = URLSession.shared
    urlRequest.httpMethod = "GET"
    
    urlRequest.httpBody = nil
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
        (data, response, error) -> Void in
        
        if error != nil {
            print("Error occurred: "+(error?.localizedDescription)!)
            return;
        }
        
        
        do {
            let responseObjc = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: AnyObject]]
            completionHandler(responseObjc as NSArray)
        }
        catch {
            print("Error occurred parsing data: \(error)")
            completionHandler([])
        }
    })
    
    task.resume()
}

}
