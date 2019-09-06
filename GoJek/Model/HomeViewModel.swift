//
//  HomeViewModel.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit


protocol HomeViewModelling {
    
    func getContect( completationHandler: @escaping (_ contactResponce: HomeModel,  _ success: Bool)-> Void)
}

class HomeViewModel: HomeViewModelling {

}
