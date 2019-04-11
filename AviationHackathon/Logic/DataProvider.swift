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
    case meal = "meal"
    case toggleSleep = "sleep"
}

class DataProvider {
    
    let flightAPIBaseURL = "http://192.168.8.210/"
    let mealsAPIBaseURL = "http://192.168.8.210:1883/"
    let noderedAPIBaseURL = "http://192.168.8.210:1883/"
    
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
    
    func getCurrentTemperatureData(withBlock block: @escaping (JSON) -> ()) {
        
        let url = "http://192.168.8.210:1883/currentTemperature"
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                if let data = response.result.value {
                    
                    block(JSON(data))
                }
                
            }
        }
    }
    
    func save(Meal meal: Meal, andDessert dessert: Meal, withBlock block: () -> ()) {
        
        let mealParameters: Parameters = [
            "name": meal.name,
            "vegetarian": meal.vegetarian,
            "comfortClass": meal.comfortClass,
            "type": meal.type
        ]
        
        let dessertParameters: Parameters = [
            "name": dessert.name,
            "vegetarian": dessert.vegetarian,
            "comfortClass": dessert.comfortClass,
            "type": dessert.type
        ]
        
        Alamofire.request("\(mealsAPIBaseURL)\(APIEndpoint.meal)", method: .post, parameters: mealParameters, encoding: JSONEncoding.default)
        Alamofire.request("\(mealsAPIBaseURL)\(APIEndpoint.meal)", method: .post, parameters: dessertParameters, encoding: JSONEncoding.default)
        
        block()
        
    }
    
    func save(TargetTemp temp: Int, withBlock block: () -> ()) {
        
        let params: Parameters = [
            "temp": temp,
        ]
        
        Alamofire.request("http://192.168.8.210:1883/temperature", method: .post, parameters: params, encoding: JSONEncoding.default)
        
        block()
        
    }
    
    func toggleSleepMode(IntoStatus status: Int, withBlock block: @escaping () -> ()) {
        
        let params: Parameters = [
            "status": status
        ]
        
        Alamofire.request("http://192.168.8.210:1883/sleep", method: .post, parameters: params, encoding: JSONEncoding.default).response { response in
            
            if response.response?.statusCode == 200 {
                block()
            }
        }
    }
    
}
