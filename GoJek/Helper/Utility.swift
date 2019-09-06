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

}
