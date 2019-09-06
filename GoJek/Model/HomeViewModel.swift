//
//  HomeViewModel.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit
import ObjectMapper


protocol HomeViewModelling {
    
    func getContact(contactHandler: @escaping (_ contactResponce: [HomeModel],  _ success: Bool)-> Void)
}

class HomeViewModel: HomeViewModelling {
    func getContact(contactHandler: @escaping ([HomeModel], Bool) -> Void) {
        
        let requestURL = URL(string: String(format: "%@%@",kBaseUrl,kContact))!
        
        NetworkManager.shared.getRequest(requestURL,completionHandler:{(contact) in
            
            print(contact)

            let contactList = Mapper<HomeModel>().mapArray(JSONArray: contact as! [[String : Any]] )
               contactHandler(contactList,true)
          
           
            })

    }
    

}
