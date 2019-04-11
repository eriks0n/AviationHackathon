//
//  SecondViewController.swift
//  AviationHackathon
//
//  Created by Lennart Erikson on 11.04.19.
//  Copyright © 2019 Lennart Erikson. All rights reserved.
//

import UIKit

class MealViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var selectedMealNameLabel: UILabel!
    @IBOutlet weak var selectedMealImageView: UIImageView!
    @IBOutlet weak var selectedMealVegetarianInfoLabel: UILabel!
    
    
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
            
            if let meal = selectedMeal {
                
                mealTableVC.selectedMeal = meal
            }
            
        }
    }
}

extension MealViewController: MealsTableViewControllerDelegate {
    
    func mealsTableViewControllerDidFinishPicking(Meal meal: Meal) {
     
        selectedMeal = meal
    }
}

