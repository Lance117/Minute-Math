//
//  MainMenuViewController.swift
//  Minute Math
//
//  Created by Lance Wong on 6/1/18.
//  Copyright © 2018 Lance Wong. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let destinationVC = segue.destination as! ViewController
        
        // Pass the selected object to the new view controller.
        if segue.identifier == "firstGrade" {
            destinationVC.limits = 10
            destinationVC.numOperators = 2
            destinationVC.gradeLevel = 1
            destinationVC.highScoreKey = "firstHighScore"
        } else if segue.identifier == "secondGrade" {
            destinationVC.limits = 50
            destinationVC.numOperators = 3
            destinationVC.gradeLevel = 2
            destinationVC.highScoreKey = "secondHighScore"
        } else if segue.identifier == "thirdGrade" {
            destinationVC.limits = 80
            destinationVC.numOperators = 4
            destinationVC.gradeLevel = 3
            destinationVC.highScoreKey = "thirdHighScore"
        } else if segue.identifier == "fourthGrade" {
            destinationVC.limits = 100
            destinationVC.numOperators = 4
            destinationVC.gradeLevel = 4
            destinationVC.highScoreKey = "fourthHighScore"
        } else if segue.identifier == "fifthGrade" {
            destinationVC.limits = 1000
            destinationVC.numOperators = 4
            destinationVC.gradeLevel = 5
            destinationVC.highScoreKey = "fifthHighScore"
        }
    }
    

}
