//
//  ViewController.swift
//  Minute Math
//
//  Created by Lance Wong on 5/30/18.
//  Copyright © 2018 Lance Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var isCorrectLabel: UILabel!
    @IBOutlet weak var mathQuestion: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var scoreSummaryButton: UIButton!
    @IBOutlet var scoreSummaryView: UIView!
    @IBOutlet weak var numCorrectLabel: UILabel!
    @IBOutlet weak var numWrongLabel: UILabel!
    @IBOutlet weak var numTotalLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    // MARK: Variables
    private var timeRemaining = 60
    private var timer = Timer()
    private var n1 = 0
    private var n2 = 0
    private var solution = 0
    private var mathOperator = 0
    private var score = 0
    private var correct = 0
    private var wrong = 0
    private var total = 0
    private var sign = ""
    private var highScore = 0
    var highScoreKey = ""
    var numOperators: UInt32 = 0
    var limits: UInt32 = 0
    var gradeLevel = 0
    let HighscoreDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        answerField.delegate = self
        
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        submitButton.isHidden = false
        submitButton.isUserInteractionEnabled = false
        tryAgainButton.isUserInteractionEnabled = false
        submitButton.isEnabled = false
        //tryAgainButton.isHidden = true
        //mainMenuButton.isHidden = true
        isCorrectLabel.isHidden = true
        scoreSummaryButton.isHidden = true
        
        // Get high score
        if let highscore = HighscoreDefault.value(forKey: highScoreKey) as? Int {
            self.highScore = highscore
            highScoreLabel.text = "\(highScore)"
        }
        
        timeLabel.textColor = UIColor.black
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        genQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        self.view.endEditing(true)
        if touch?.view != scoreSummaryView {
            self.scoreSummaryView.removeFromSuperview()
        }
    }

    //MARK: UITextFieldDelegate    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty {
            submitButton.isUserInteractionEnabled = true
            submitButton.isEnabled = true
        } else {
            submitButton.isUserInteractionEnabled = false
            submitButton.isEnabled = false
        }
        return true
    }
    
    // MARK: Actions
    @IBAction func submitAnswer(_ sender: UIButton) {
        self.view.endEditing(true)

        if sender.currentTitle == "SUBMIT" {
            sender.setTitle("CONTINUE", for: .normal)
            
            // Check answer, tell user if correct or wrong.
            if Int(answerField.text!) == solution {
                score += 1
                correct += 1
                scoreLabel.text = "\(score)"
                isCorrectLabel.text = "You are correct."
                isCorrectLabel.textColor = UIColor.green
            } else {
                wrong += 1
                if score > 0 {
                    score -= 1
                }
                scoreLabel.text = "\(score)"
                isCorrectLabel.text = "You are wrong."
                mathQuestion.text = "\(n1) \(sign) \(n2) = \(solution)"
                mathQuestion.textColor = UIColor.blue
                isCorrectLabel.textColor = UIColor.red
            }
            isCorrectLabel.isHidden = false
        } else {
            sender.setTitle("SUBMIT", for: .normal)
            isCorrectLabel.isHidden = true
            submitButton.isUserInteractionEnabled = false
            submitButton.isEnabled = false
            answerField.text = ""
            genQuestion()
        }
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        score = 0
        wrong = 0
        total = 0
        timeRemaining = 60
        scoreLabel.text = "0"
        timeLabel.text = "60"
        self.scoreSummaryView.removeFromSuperview()
        viewDidLoad()
    }

    @IBAction func getScoreSummary(_ sender: Any) {
        if correct + wrong == 0 {
            total = 0
        } else {
            total = (correct * 100) / (correct + wrong)

        }
        numCorrectLabel.text = "Correct: \(correct)"
        numWrongLabel.text = "Wrong: \(wrong)"
        numTotalLabel.text = "Accuracy: \(total)%"
        UIView.transition(with: self.view, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {self.view.addSubview(self.scoreSummaryView)}, completion: nil)
        scoreSummaryView.center = self.view.center
    }
    
    @IBAction func goBackHome(_ sender: Any) {
        let alert = UIAlertController(title: "Back home", message: "Are you sure you want to leave?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { (action) in
            self.performSegue(withIdentifier:"backHome", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            print("Cancelled")
        }))
        
        self.present(alert, animated: true)
    }
    
    // MARK: Private Methods
    @objc private func timerRunning() {
        timeRemaining -= 1
        timeLabel.text = "\(timeRemaining)"
        if timeRemaining < 11 {
            timeLabel.textColor = UIColor.red
        }
        if timeRemaining == 0 {
            timer.invalidate()
            submitButton.isHidden = true
            scoreSummaryButton.isHidden = false
            tryAgainButton.isUserInteractionEnabled = true
            //tryAgainButton.isHidden = false
            //mainMenuButton.isHidden = false
            submitButton.setTitle("SUBMIT", for: .normal)
            answerField.text = ""
            isCorrectLabel.text = "Time's Up!"
            mathQuestion.text = "\(n1) \(sign) \(n2) = \(solution)"
            mathQuestion.textColor = UIColor.blue
            isCorrectLabel.textColor = UIColor.red
            isCorrectLabel.isHidden = false
            if score > highScore {
                HighscoreDefault.set(score, forKey: highScoreKey)
                highScoreLabel.text = "\(score)"
            }
        }
    }
    
    private func genQuestion() {
        // Math levels specs - https://www.homeschoolmath.net/worksheets/
        
        n1 = Int(arc4random_uniform(limits))
        n2 = Int(arc4random_uniform(limits))
        mathOperator = Int(arc4random_uniform(numOperators))
        
        // Generate a question.
        if mathOperator == 0 {
            sign = "+"
            solution = n1 + n2
        } else if mathOperator == 1 {
            if gradeLevel == 2 {
                n2 = Int(arc4random_uniform(UInt32(11)))
            }
            if n2 > n1 {
                n2 = Int(arc4random_uniform(UInt32(n1)))
            }
            sign = "-"
            solution = n1 - n2
        } else if mathOperator == 2 {
            sign = "x"
            if gradeLevel == 2 {
                n1 = Int(arc4random_uniform(10))
                n2 = Int(arc4random_uniform(10))
            } else if gradeLevel == 3 {
                n1 = Int(arc4random_uniform(13))
                if n1 > 10 {
                    n2 = Int(arc4random_uniform(11))
                } else {
                    n2 = Int(arc4random_uniform(13))
                }
            } else if gradeLevel == 4 {
                n1 = Int(arc4random_uniform(1000))
                if n1 > 10 {
                    n2 = Int(arc4random_uniform(11))
                } else {
                    n2 = Int(arc4random_uniform(1000))
                }
            } else if gradeLevel == 5 {
                if n1 > 10 {
                    n2 = Int(arc4random_uniform(11))
                }
            }
            solution = n1 * n2
        } else {
            sign = "÷"
            if gradeLevel == 3 {
                n2 = Int(arc4random_uniform(9) + 1)
                n1 = Int(arc4random_uniform(13)) * n2
            } else if gradeLevel == 4 {
                n2 = Int(arc4random_uniform(12) + 1)
                n1 = Int(arc4random_uniform(13)) * n2
            } else if gradeLevel == 5 {
                n2 = Int(arc4random_uniform(12) + 1)
                if n2 > 9 {
                    n1 = Int(arc4random_uniform(13)) * n2
                } else {
                    n1 = Int(arc4random_uniform(1000)) * n2
                }
            }
            solution = n1 / n2
        }
        // Display math question in game
        mathQuestion.text = "\(n1) \(sign) \(n2) = ____"
        mathQuestion.textColor = UIColor.black
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        bottom.constant = keyboardFrame.size.height + 1
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        bottom.constant = 6
    }
}

