//
//  FirstViewController.swift
//  AviationHackathon
//
//  Created by Lennart Erikson on 11.04.19.
//  Copyright © 2019 Lennart Erikson. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class SleepViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var distanceRemainingLabel: UILabel!
    
    @IBOutlet weak var dndImageView: UIImageView!
    @IBOutlet weak var windowImageView: UIImageView!
    @IBOutlet weak var toggleSleepModeButton: UIButton!
    
    @IBOutlet weak var dndLabel: UILabel!
    @IBOutlet weak var windowsLabel: UILabel!
    
    
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
                
                dndImageView.image = UIImage(named: "foggy-night-active")
                windowImageView.image = UIImage(named: "airplane-window-closed-1")
                
                dndLabel.text = "Do not Disturb: ✅"
                windowsLabel.text = "Windows: Closed"
                
                
            } else {
                
                dndImageView.image = UIImage(named: "foggy-night")
                windowImageView.image = UIImage(named: "airplane-window-open-1")
                
                dndLabel.text = "Do not Disturb: ❌"
                windowsLabel.text = "Windows: Open"

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
        toggleSleepModeButton.isEnabled = false
        
        let statusToTrigger = isSleepModeEnabled == true ? 1 : 0
        dataProvider.toggleSleepMode(IntoStatus: statusToTrigger) {
            
            SVProgressHUD.setSuccessImage(UIImage(named: "sleeping-in-bed")!)
            SVProgressHUD.setMaximumDismissTimeInterval(TimeInterval(exactly: 0.7)!)
            SVProgressHUD.showSuccess(withStatus: "You're set!")
            
            self.toggleSleepModeButton.isEnabled = true
        }
    }
    
    
}

