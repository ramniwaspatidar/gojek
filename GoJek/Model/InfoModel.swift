//
//  InfoModel.swift
//  GoJek
//
//  Created by Ram Niwas on 9/7/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit

enum ContactType {
    case first_name
    case last_name
    case phone_number
    case email
}

struct InfoStruct {
    var type: ContactType!
    var value: String!
    var placeholder:String!
    
    init(type : ContactType, value : String, placeHolder : String) {
        self.type = type
        self.value = value
        self.placeholder = placeHolder
    }
}
