//
//  AddContactVM.swift
//  GoJek
//
//  Created by Ram Niwas on 9/7/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit

protocol AddInfoViewModelling {
    func prepareInfo(dictInfo : [String : AnyObject]) -> [InfoStruct]
    
    func validateFields(addDataArray : [InfoStruct], validHandler : @escaping (_ param : [String : AnyObject], _ msg : String, _ sucess: Bool) -> Void)
    

//    func callApiEditProfile(param: [String : AnyObject], editProfileHandler: @escaping ( _ isSuccess: Bool, _ msg: String, _ isOtp: Bool, _ mobileNumber: String) -> Void)
}


class AddContactVM: AddInfoViewModelling {
    
    func prepareInfo(dictInfo: [String : AnyObject]) -> [InfoStruct] {
        var infoData = [InfoStruct]()
        infoData.append(InfoStruct(type: .first_name, value: dictInfo["first_name"] as? String ?? "", placeHolder: "First Name"))
        infoData.append(InfoStruct(type: .last_name, value: dictInfo["last_name"] as? String ?? "", placeHolder: "Last Name"))
         infoData.append(InfoStruct(type: .phone_number, value: dictInfo["phone_number"] as? String ?? "", placeHolder: "Mobile"))
         infoData.append(InfoStruct(type: .email, value: dictInfo["email"] as? String ?? "", placeHolder: "Email"))
        
        return infoData
    }
    
    func validateFields(addDataArray: [InfoStruct], validHandler: @escaping ([String : AnyObject], String, Bool) -> Void) {
        
        var dictParam = [String : AnyObject]()
        for index in 0..<addDataArray.count {
            switch addDataArray[index].type {
            case .first_name?:
                if addDataArray[index].value.trimmingCharacters(in: .whitespaces) == "" {
                   
                    validHandler([:],"Enter first name", false)
                    return
                }
                dictParam["first_name"] = addDataArray[index].value.trimmingCharacters(in: .whitespaces) as AnyObject
            case .last_name?:
                if addDataArray[index].value.trimmingCharacters(in: .whitespaces) == "" {
                    validHandler([:], "Enter last name", false)
                    return
                }
                dictParam["last_name"] = addDataArray[index].value.trimmingCharacters(in: .whitespaces) as AnyObject
      
           
            case .phone_number?:
                if addDataArray[index].value.trimmingCharacters(in: .whitespaces) == ""  {
                    validHandler([:], "Enter mobile number with country code", false)
                    return
                }
                
                dictParam["phone_number"] = addDataArray[index].value.trimmingCharacters(in: .whitespaces) as AnyObject
                
            case .email?:
                if addDataArray[index].value.trimmingCharacters(in: .whitespaces) == "" {
                    validHandler([:], "Enter email", false)
                    return
                }
                else if !Utility.util.isValidEmail(testStr: addDataArray[index].value.trimmingCharacters(in: .whitespaces)) {
                    validHandler([:], "Enter valid email", false)
                    return
                }
                dictParam["email"] = addDataArray[index].value.trimmingCharacters(in: .whitespaces) as AnyObject
         
            case .none:
                break
           
            }
        }
        validHandler(dictParam, "", true)
    }
        
    }
    


