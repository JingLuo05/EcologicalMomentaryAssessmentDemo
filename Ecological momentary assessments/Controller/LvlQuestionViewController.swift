//
//  QuestionViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/7.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit

class LvlQuestionViewController: UIViewController {
    var dataBrain = LevelDataBrain()
    var choiceDataBrain = ChoiceDataBrain()
    var questionText: String?
    var levelResult: Float = 0
    var shouldPerformSegue: Bool = false
    
    //First question show before, so set current question = 1
    
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = questionText
    }
    
    @IBAction func levelSelected(_ sender: UISlider) {
        levelResult = sender.value
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        //store current answer
//        print(dataBrain.currentLevelQuestion)
//        print(levelResult)
        
        dataBrain.levelAnswer.append(levelResult)
//        print(dataBrain.levelAnswer)
        
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateLevelUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateLevelUI() {
        if dataBrain.getNextLevelQuestion() {
            questionLabel.text = dataBrain.getLevelQuestionText()
        } else {
            //!!!!!!!!!!!!!!!!!!!!!
            shouldPerformSegue = true
            performSegue(withIdentifier: "goToChoiceQuestion", sender: self)
            print("-> perform segue!!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //!!!!!!!!!!!!!!!!!!!!!
        if shouldPerformSegue(withIdentifier: "goToChoiceQuestion", sender: UIButton.self) {
            let destinationVC = segue.destination as! ChoiceQuestionViewController
            destinationVC.questionText = choiceDataBrain.getChoiceQuestionText()
            
            let totalQuestion = choiceDataBrain.choiceQuestions.count - 1
            let currentOptions = choiceDataBrain.getQuestionOptions()
            print(currentOptions)
            
            for i in 0...totalQuestion {
                for j in 0...5 {
                    destinationVC.options.append(currentOptions[j])
                }
            }
        }
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        //!!!!!!!!!!!!!!!!!!!!!
        if identifier == "goToChoiceQuestion" {
            if shouldPerformSegue(withIdentifier: "goToChoiceQuestion", sender: Any?.self)
            {
                performSegue(withIdentifier: "goToChoiceQuestion", sender: self)
            }
        }
    }
    //!!!!!!!!!!!!!!!!!!!!!
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return shouldPerformSegue
    }
    
    
    
    
}
