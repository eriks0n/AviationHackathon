//
//  SecondViewController.swift
//  AviationHackathon
//
//  Created by Lennart Erikson on 11.04.19.
//  Copyright © 2019 Lennart Erikson. All rights reserved.
//

import UIKit
import SVProgressHUD

class MealViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var selectedMealNameLabel: UILabel!
    @IBOutlet weak var selectedMealImageView: UIImageView!
    @IBOutlet weak var selectedMealVegetarianInfoLabel: UILabel!
    
    @IBOutlet weak var selectedDessertNameLabel: UILabel!
    @IBOutlet weak var selectedDessertImageView: UIImageView!
    @IBOutlet weak var selectedDessertVegetarianInfoLabel: UILabel!
    
    
    
    // MARK: - Instance Variables
    
    var selectedMeal: Meal? {
        
        didSet {
            
            if let meal = selectedMeal {
                
                selectedMealNameLabel.text = meal.name
                selectedMealVegetarianInfoLabel.isHidden = !meal.vegetarian
                
                selectedMealImageView.image = meal.comfortClass == "Business" ? UIImage(named: "business-food") : UIImage(named: "eco-food")
                
            }
        }
    }
    
    var selectedDessert: Meal? {
        
        didSet {
            
            if let dessert = selectedDessert {
                
                selectedDessertNameLabel.text = dessert.name
                selectedDessertVegetarianInfoLabel.isHidden = !dessert.vegetarian
                
                selectedDessertImageView.image = dessert.comfortClass == "Business" ? UIImage(named: "business-cupcake") : UIImage(named: "eco-cupcake")
                
            }
        }
    }
    
    let dataProvider = DataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        selectedMealVegetarianInfoLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chooseMealSegue" {
            
            let navigationController = segue.destination as! UINavigationController
            
            let mealTableVC = navigationController.topViewController as! MealsTableViewController
            mealTableVC.delegate = self
            
            if let meal = selectedMeal, let dessert = selectedDessert {
                
                mealTableVC.selectedMeal = meal
                mealTableVC.selectedDessert = dessert
            }
            
        }
    }
}

extension MealViewController: MealsTableViewControllerDelegate {
    
    func mealsTableViewControllerDidFinishPicking(Meal meal: Meal, andDessert dessert: Meal) {
     
        // Start of network connectivity
        SVProgressHUD.show(withStatus: "Telling our chefs 👩🏻‍🍳")
        
        selectedMeal = meal
        selectedDessert = dessert
        
        // Request save
        dataProvider.save(Meal: selectedMeal!, andDessert: selectedDessert!) {
            SVProgressHUD.dismiss()
        }
        
    }
}

