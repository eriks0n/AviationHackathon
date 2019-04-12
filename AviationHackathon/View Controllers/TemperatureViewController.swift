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
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    // MARK: - Instance Variables
    let dataProvider = DataProvider()
    
    var targetTemperature: Int = 20
    var currentTemperature: Int = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let valueOption = AGCircularPickerValueOption(minValue: 18, maxValue: 24, initialValue: 20)
        let titleOption = AGCircularPickerTitleOption(title: "Temperature", titleFont: UIFont(name: "Montserrat-Medium", size: 17.0)!)
        let tempColorOption = AGCircularPickerColorOption(gradientColors: [UIColor.rgb_color(r: 39, g: 174, b: 96), UIColor.rgb_color(r: 243, g: 156, b: 18), UIColor.rgb_color(r: 231, g: 76, b: 60)], gradientAngle: 90)
        let option = AGCircularPickerOption(valueOption: valueOption, titleOption: titleOption, colorOption: tempColorOption)
        circularPickerView.setupPicker(delegate: self, option: option)
        
        targetTemperatureLabel.text = "Target: \(targetTemperature) °C"
        updateCurrentTemperature()

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
        dataProvider.getCurrentTemperatureData { (data) in
         
            self.currentTemperature = data[0]["temperature"].intValue
            self.currentTemperatureLabel.text = "Currently: \(self.currentTemperature) °C"
        }
        
        if currentTemperature < targetTemperature {
            
            temperatureImageView.image = UIImage(named: "high-temperature")
        } else {
            temperatureImageView.image = UIImage(named: "low-temperature")
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
