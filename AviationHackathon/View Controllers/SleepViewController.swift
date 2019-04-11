//
//  FirstViewController.swift
//  AviationHackathon
//
//  Created by Lennart Erikson on 11.04.19.
//  Copyright © 2019 Lennart Erikson. All rights reserved.
//

import UIKit
import SwiftyJSON

class SleepViewController: UIViewController {
    
    // MARK: - IBActions
    
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var distanceRemainingLabel: UILabel!
    
    // MARK: - Instance variables
    let dataProvider = DataProvider()
    
    lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        
        return formatter
    
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get flight data
        dataProvider.getFlightData { (data) in
            
            guard let etaString = data["time"]["estimatedArrival"].rawString() else {
                
                self.etaLabel.text = "ETA not available 😭"
                return
            }
            
            self.etaLabel.text = etaString
            
            
            let distanceRemaining = data["totalDistance"].doubleValue - data["distanceFlown"].doubleValue
            
            self.distanceRemainingLabel.text = String(format: "%.2f", distanceRemaining)
            
        }
    }


}

