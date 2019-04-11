//
//  TemperatureViewController.swift
//  AviationHackathon
//
//  Created by Lennart Erikson on 11.04.19.
//  Copyright © 2019 Lennart Erikson. All rights reserved.
//

import UIKit
import AGCircularPicker

class TemperatureViewController: UIViewController {
    
    @IBOutlet weak var circularPickerView: AGCircularPickerView!
    @IBOutlet weak var targetTemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let valueOption = AGCircularPickerValueOption(minValue: 18, maxValue: 23)
        let titleOption = AGCircularPickerTitleOption(title: "Temperature")
        let option = AGCircularPickerOption(valueOption: valueOption, titleOption: titleOption)
        circularPickerView.setupPicker(delegate: self, option: option)

    }
    
    func updateTargetTemperature(WithTemperature temp: Int) {
        
        targetTemperatureLabel.text = "Target: \(temp) °C"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
