//
//  MealsTableViewController.swift
//  AviationHackathon
//
//  Created by Lennart Erikson on 11.04.19.
//  Copyright © 2019 Lennart Erikson. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol MealsTableViewControllerDelegate {
    func mealsTableViewControllerDidFinishPicking(Meal meal: Meal)
}

class MealsTableViewController: UITableViewController {
    
    // MARK: - Instance Variables
    
    let dataProvider = DataProvider()
    var businessMeals = [Meal]()
    var economyMeals = [Meal]()
    
    var selectedMeal = Meal()
    
    var delegate: MealsTableViewControllerDelegate?
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAvailableMeals()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? businessMeals.count : economyMeals.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "Business Meals" : "Economy Meals"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)

        let mealForCell = indexPath.section == 0 ? businessMeals[indexPath.row] : economyMeals[indexPath.row]
        
        cell.textLabel?.text = mealForCell.name
        
        if mealForCell.vegetarian == true {
            cell.imageView?.image = UIImage(named: "vegetarian-mark")
        } else {
            cell.imageView?.image = UIImage(named: "beef")
        }
        
        if mealForCell.name == selectedMeal.name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
 
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for cell in tableView.visibleCells {
            
            cell.accessoryType = .none
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedMeal = indexPath.section == 0 ? businessMeals[indexPath.row] : economyMeals[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Business Logic
    
    func loadAvailableMeals() {
        
        // Get meal data
        dataProvider.getMealData() { (data) in
            
            for meal in data["meals"] {
                
                let newMeal = Meal()
                newMeal.name = meal.1["name"].stringValue
                newMeal.vegetarian = meal.1["vegetarian"].boolValue
                newMeal.comfortClass = meal.1["comfortClass"].stringValue
                
                newMeal.comfortClass == "Business" ? self.businessMeals.append(newMeal) : self.economyMeals.append(newMeal)
            }
            
            self.tableView.reloadData()
            
        }
    }
    

    // MARK: - Navigation
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        delegate?.mealsTableViewControllerDidFinishPicking(Meal: selectedMeal)
        
        dismiss(animated: true, completion: nil)
    }
    

}
