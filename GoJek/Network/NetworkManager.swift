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
    
    
    //MARK:  request method
    
    func getRequest(_ url: URL, completionHandler:@escaping (_ response: AnyObject) -> Void) {
        
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
    
    func addContactWithImage(_ dict:[String : AnyObject],urlStr:NSString,img:UIImage, completionHandler:@escaping (_ response: NSDictionary) -> Void) {
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: urlStr as String)!)
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"

        let boundary = generateBoundaryString()
        
        let contentType = NSString(format: "application/json; boundary=%@",boundary)
        urlRequest.addValue(contentType as String   , forHTTPHeaderField: "Content-Type")
        
        
        let imgData : Data = img.jpegData(compressionQuality: 70)!
        urlRequest.httpBody = postBodyWithParameters(dict, filePathKey: "file", imageDataKey: imgData, boundary: boundary)
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            
            (data, response, error) -> Void in
            
            
            if error != nil {
                print("Error occurred: "+(error?.localizedDescription)!)
                
                DispatchQueue.main.sync {
                    let _ :AppDelegate = UIApplication.shared.delegate as! AppDelegate
                }
//                completionHandler(nil, error)
                return;
            }
            do {
                
                _ = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers]) as! [String: Any]
                DispatchQueue.main.sync {
//                    completionHandler(responseObjc, nil)
                }
            }
            catch {
                
                print("Error occurred parsing data: \(error.localizedDescription)")
                let strData = String(decoding: data!, as: UTF8.self)
                //                    let errDict = NSMutableDictionary()
                //                    errDict.setValue(strData, forKey: "error")
                var errDict = [String: Any]()
                errDict["error"] = strData
            //    completionHandler(errDict, error)
                
                return;
            }
        })
        
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    func postBodyWithParameters(_ dict:[String :AnyObject], filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
      var body = Data()
        let date = Date()
        let filename : String =  String(date.timeIntervalSince1970)
        let mimetype = "image/jpg"
        
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(imageDataKey)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body as Data
    }
    
//    func addContactWithImage(_ dict:[String : AnyObject],urlStr:NSString,img:UIImage, completionHandler:@escaping (_ response: NSDictionary) -> Void) {
//
//        let filename = "profile.png"
//        let boundary = UUID().uuidString
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//
//        var urlRequest = URLRequest(url: URL(string: "https://catbox.moe/user/api.php")!)
//        urlRequest.httpMethod = "POST"
//
//        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        var data = Data()
//
//        // first name
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\("first_name")\"\r\n\r\n".data(using: .utf8)!)
//        data.append("\(String(describing: dict["first_name"]))".data(using: .utf8)!)
//
//        // lastname
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\("last_name")\"\r\n\r\n".data(using: .utf8)!)
//        data.append("\(String(describing: dict["last_name"]))".data(using: .utf8)!)
//
//        // email
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\("email")\"\r\n\r\n".data(using: .utf8)!)
//        data.append("\(String(describing: dict["email"]))".data(using: .utf8)!)
//
//        // mobile
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\("phone_number")\"\r\n\r\n".data(using: .utf8)!)
//        data.append("\(String(describing: dict["phone_number"]))".data(using: .utf8)!)
//
//        // profile pic
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; profile_pic=\"\(filename)\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//        data.append(img.jpegData(compressionQuality: 70)!)
//
//        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//
//        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
//
//            if(error != nil){
//                print("\(error!.localizedDescription)")
//            }
//
//            guard let responseData = responseData else {
//                print("no response data")
//                return
//            }
//
//            if let responseString = String(data: responseData, encoding: .utf8) {
//                print("uploaded to: \(responseString)")
//            }
//        }).resume()
//
//    }
    
    
   

    
}
