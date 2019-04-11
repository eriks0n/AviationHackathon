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
    func mealsTableViewControllerDidFinishPicking(Meal meal: Meal, andDessert dessert: Meal)
}

class MealsTableViewController: UITableViewController {
    
    // MARK: - Instance Variables
    
    let dataProvider = DataProvider()
    var businessMeals = [Meal]()
    var economyMeals = [Meal]()
    
    var selectedMeal = Meal()
    var selectedDessert = Meal()
    
    var delegate: MealsTableViewControllerDelegate?
    
    // Used to make sure there are no more than two checkmarks
    var lastDessertIndexPath: IndexPath?
    var lastMealIndexPath: IndexPath?
    
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
        
        return section == 0 ? "Business Class" : "Economy Class"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)

        let mealForCell = indexPath.section == 0 ? businessMeals[indexPath.row] : economyMeals[indexPath.row]
        
        cell.textLabel?.text = mealForCell.name
        cell.detailTextLabel?.text = mealForCell.type
        
        // if vegi
        
        if mealForCell.vegetarian == true {
            cell.imageView?.image = UIImage(named: "vegetarian-mark")
        } else {
            cell.imageView?.image = UIImage(named: "beef")
        }
        
        
        // setting name of cell
        if mealForCell.name == selectedMeal.name  {
            
            cell.accessoryType = .checkmark
            lastMealIndexPath = indexPath
            
        } else if mealForCell.name == selectedDessert.name {
            
            cell.accessoryType = .checkmark
            lastDessertIndexPath = indexPath
        } else {
            
            cell.accessoryType = .none
        }
        
        
 
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        // accessory type (none or checkmark)
        cell?.accessoryType = .checkmark
        
        let selectedItem = indexPath.section == 0 ? businessMeals[indexPath.row] : economyMeals[indexPath.row]
        
        if selectedItem.type == "Meal" {
            
            selectedMeal = selectedItem
            
            if let lastIndex = lastMealIndexPath {
                
                let cell = tableView.cellForRow(at: lastIndex)
                cell?.accessoryType = .none
            }
            
            lastMealIndexPath = indexPath
            
        } else if selectedItem.type == "Dessert" {
            
            selectedDessert = selectedItem
            
            if let lastIndex = lastDessertIndexPath {
                
                let cell = tableView.cellForRow(at: lastIndex)
                cell?.accessoryType = .none
            }
            
            lastDessertIndexPath = indexPath
        }
        
        // deselect row
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
                newMeal.type = meal.1["type"].stringValue
                
                newMeal.comfortClass == "Business" ? self.businessMeals.append(newMeal) : self.economyMeals.append(newMeal)
            }
            
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Navigation
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        delegate?.mealsTableViewControllerDidFinishPicking(Meal: selectedMeal, andDessert: selectedDessert)
        
        dismiss(animated: true, completion: nil)
    }
    

}
