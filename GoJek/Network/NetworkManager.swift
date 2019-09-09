//
//  NetworkManager.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

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
        
        SVProgressHUD.show()
        
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {(data, response, error) in
            
            SVProgressHUD.dismiss()

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
    
    
    //MARK:  request method
    
    func getRequest(_ url: URL, completionHandler:@escaping (_ response: AnyObject) -> Void) {
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        urlRequest.httpMethod = "GET"
        
        urlRequest.httpBody = nil
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        SVProgressHUD.show()

        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            SVProgressHUD.dismiss()
            if error != nil {
                print("Error occurred: "+(error?.localizedDescription)!)
                return;
            }
            
            do {
                let responseObjc = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                completionHandler(responseObjc as AnyObject)
            }
            catch {
                print("Error occurred parsing data: \(error)")
                completionHandler([] as AnyObject)
            }
        })
        
        task.resume()
    }
    
    // MARK - Post request with image
    
    func addContactWithImage(_ parameters:[String : AnyObject],url:String,img:UIImage, completionHandler:@escaping (_ response: String) -> Void) {
        
        print(parameters)
        let imageData : Data = img.jpegData(compressionQuality:  0.75)!

        print(imageData)
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"]
        SVProgressHUD.show()

        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                multipartFormData.append(imageData, withName: "profile_pic", fileName: "file.jpeg", mimeType: "image/jpeg")
                for (key, value) in parameters
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }

        }, to:url,headers:headers){ (result) in
            
            
            switch result{
                
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    SVProgressHUD.dismiss()

                    completionHandler("1")
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completionHandler("0")

                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
}
