//
//  TemperatureViewController.swift
//  AviationHackathon
//
//  Created by Lennart Erikson on 11.04.19.
//  Copyright © 2019 Lennart Erikson. All rights reserved.
//

import UIKit
import AGCircularPicker
import SVProgressHUD

class TemperatureViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var circularPickerView: AGCircularPickerView!
    @IBOutlet weak var targetTemperatureLabel: UILabel!
    @IBOutlet weak var temperatureImageView: UIImageView!
    
    // MARK: - Instance Variables
    let dataProvider = DataProvider()
    
    var targetTemperature: Int = 20
    var currentTemperature: Int = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let valueOption = AGCircularPickerValueOption(minValue: 18, maxValue: 23)
        let titleOption = AGCircularPickerTitleOption(title: "Temperature")
        let option = AGCircularPickerOption(valueOption: valueOption, titleOption: titleOption)
        circularPickerView.setupPicker(delegate: self, option: option)
        
        targetTemperatureLabel.text = "Target: \(targetTemperature) °C"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCurrentTemperature()
    }
    
    func updateTargetTemperature(WithTemperature temp: Int) {
        
        targetTemperatureLabel.text = "Target: \(temp) °C"
        targetTemperature = temp
        
        updateCurrentTemperature()
        
    }
    
    func updateCurrentTemperature() {
        
        // Update with data from server
        
        if currentTemperature < targetTemperature {
            
            temperatureImageView.image = UIImage(named: "low-temperature")
        } else {
            temperatureImageView.image = UIImage(named: "high-temperature")
        }
    }
    

    // MARK: - IBActions
    @IBAction func saveTemperatureButtonPressed(_ sender: UIButton) {
        
        dataProvider.save(TargetTemp: targetTemperature) {
            
            SVProgressHUD.setSuccessImage(UIImage(named: "high-temperature")!)
            SVProgressHUD.setMaximumDismissTimeInterval(TimeInterval(exactly: 0.7)!)
            SVProgressHUD.showSuccess(withStatus: "Temperature set.")
        }
        
    }
    
}

extension TemperatureViewController: AGCircularPickerViewDelegate {
    
    func circularPickerViewDidChangeValue(_ value: Int, color: UIColor, index: Int) {
       
        updateTargetTemperature(WithTemperature: value)
    }
    
    func circularPickerViewDidEndSetupWith(_ value: Int, color: UIColor, index: Int) {
    }
    
    func didBeginTracking(timePickerView: AGCircularPickerView) {
        
    }
    
    func didEndTracking(timePickerView: AGCircularPickerView) {
        
    }
    
}
