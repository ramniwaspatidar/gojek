//
//  HomeModel.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit
import ObjectMapper


class HomeModel: NSObject, Codable, Mappable {
    var id: Int?
    var first_name: String?
    var last_name: String?
    var profile_pic: String?
    var favorite: Bool?
    var url: String?
    var phone_number : String?
   
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        profile_pic <- map["profile_pic"]
        favorite <- map["favorite"]
        url <- map["url"]
        phone_number <- map["phone_number"]
    }
}
