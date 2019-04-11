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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var distanceRemainingLabel: UILabel!
    
    @IBOutlet weak var dndImageView: UIImageView!
    @IBOutlet weak var windowImageView: UIImageView!
    @IBOutlet weak var toggleSleepModeButton: UIButton!
    
    
    // MARK: - Instance variables
    let dataProvider = DataProvider()
    
    lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        
        return formatter
    
    }()
    
    var isSleepModeEnabled = false {
        
        didSet {
            
            if isSleepModeEnabled == true {
                
                dndImageView.image = UIImage(named: "moon-and-stars-filled")
                windowImageView.image = UIImage(named: "airplane-window-closed")
                
                
            } else {
                
                dndImageView.image = UIImage(named: "moon-and-stars")
                windowImageView.image = UIImage(named: "airplane-window-open")

            }
            
        }
    }
    

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
    
    // MARK: - IBActions
    
    @IBAction func toggleSleepModeButtonPressed(_ sender: UIButton) {
        
        isSleepModeEnabled.toggle()
        
    }
    
    
}

