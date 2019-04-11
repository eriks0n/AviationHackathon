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
}

class DataProvider {
    
    let apiBaseURL = "http://192.168.8.210/"
    
    func getFlightData(withBlock block: @escaping (JSON) -> ()) {
        
        let url = "\(apiBaseURL)\(APIEndpoint.flightStatus)"
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.isSuccess {
             
                if let data = response.result.value {
                    
                    block(JSON(data))
                }
                
            }
        }
    }
    
}
