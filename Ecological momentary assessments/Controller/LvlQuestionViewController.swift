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
        dataBrain.levelAnswer.append(levelResult)
        
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateLevelUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateLevelUI() {
        if dataBrain.getNextLevelQuestion() {
            questionLabel.text = dataBrain.getLevelQuestionText()
        } else {
            shouldPerformSegue = true
            performSegue(withIdentifier: "goToChoiceQuestion", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChoiceQuestion" {
            let destinationVC = segue.destination as! ChoiceQuestionViewController
            destinationVC.questionText = choiceDataBrain.getChoiceQuestionText()
            
            let totalQuestion = choiceDataBrain.choiceQuestions.count - 1
            let currentOptions = choiceDataBrain.getQuestionOptions()

            for i in 0...totalQuestion {
                for j in 0...5 {
                    destinationVC.options.append(currentOptions[j])
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return shouldPerformSegue
    }
    
    
}
