//
//  DataProvider.swift
//  AviationHackathon
//
//  Created by Lennart Erikson on 11.04.19.
//  Copyright © 2019 Lennart Erikson. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIEndpoint: String {
    case flightStatus = "flightstatus"
    case seatMap = "seatmap"
    case meals = "meals"
}

class DataProvider {
    
    let flightAPIBaseURL = "http://192.168.8.210/"
    let mealsAPIBaseURL = "http://192.168.8.210:1883/"
    
    func getFlightData(withBlock block: @escaping (JSON) -> ()) {
        
        let url = "\(flightAPIBaseURL)\(APIEndpoint.flightStatus)"
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.isSuccess {
             
                if let data = response.result.value {
                    
                    block(JSON(data))
                }
                
            }
        }
    }
    
    func getMealData(withBlock block: @escaping (JSON) -> ()) {
        
        let url = "\(mealsAPIBaseURL)\(APIEndpoint.meals)"
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                if let data = response.result.value {
                    
                    block(JSON(data))
                }
                
            }
        }
    }
    
}
