//
//  ChoiceQuestionViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/7.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit

class ChoiceQuestionViewController: UIViewController {

    var dataBrain = ChoiceDataBrain()
    var questionText: String?
    var choiceAnswer: String = ""
    var options = [String]()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option0: UIButton!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var option5: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionLabel.text = questionText
        option0.setTitle(options[0], for: .normal)
        option1.setTitle(options[1], for: .normal)
        option2.setTitle(options[2], for: .normal)
        option3.setTitle(options[3], for: .normal)
        option4.setTitle(options[4], for: .normal)
        option5.setTitle(options[5], for: .normal)
        
    }
    
    @IBAction func choice0Selected(_ sender: UIButton) {
        dataBrain.choiceAnswer.append(dataBrain.choiceQuestions[dataBrain.currentChoiceQuestion].choices[0])
        sender.backgroundColor = UIColor.green
        
        print("Answer0 added!!")
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateChoiceUI), userInfo: nil, repeats: false)
    }
    @IBAction func choice1Selected(_ sender: UIButton) {
        dataBrain.choiceAnswer.append(dataBrain.choiceQuestions[dataBrain.currentChoiceQuestion].choices[1])
        
        print("Answer1 added!!")
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateChoiceUI), userInfo: nil, repeats: false)
    }
    
    @IBAction func choice2Selected(_ sender: UIButton) {
        dataBrain.choiceAnswer.append(dataBrain.choiceQuestions[dataBrain.currentChoiceQuestion].choices[2])
        
        print("Answer2 added!!")
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateChoiceUI), userInfo: nil, repeats: false)
    }
    
    @IBAction func choice3Selected(_ sender: UIButton) {
        dataBrain.choiceAnswer.append(dataBrain.choiceQuestions[dataBrain.currentChoiceQuestion].choices[3])
        
        print("Answer3 added!!")
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateChoiceUI), userInfo: nil, repeats: false)
    }
    
    @IBAction func choice4Selected(_ sender: UIButton) {
        dataBrain.choiceAnswer.append(dataBrain.choiceQuestions[dataBrain.currentChoiceQuestion].choices[4])
        
        print("Answer4 added!!")
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateChoiceUI), userInfo: nil, repeats: false)
    }
    
    @IBAction func choice5Selected(_ sender: UIButton) {
        dataBrain.choiceAnswer.append(dataBrain.choiceQuestions[dataBrain.currentChoiceQuestion].choices[5])
        
        print("Answer5 added!!")
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateChoiceUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateChoiceUI() {
        if dataBrain.getNextChoiceQuestion() {
            questionLabel.text = dataBrain.getChoiceQuestionText()
            options = dataBrain.getQuestionOptions()
            print(options)
            option0.setTitle(options[0], for: .normal)
            option1.setTitle(options[1], for: .normal)
            option2.setTitle(options[2], for: .normal)
            option3.setTitle(options[3], for: .normal)
            option4.setTitle(options[4], for: .normal)
            option5.setTitle(options[5], for: .normal)
            //clear color:this is a test
            //test
            option1.backgroundColor = UIColor.clear
            option1.backgroundColor = UIColor.clear
            option1.backgroundColor = UIColor.clear
            option1.backgroundColor = UIColor.clear
            option1.backgroundColor = UIColor.clear
            option1.backgroundColor = UIColor.clear
        } else {
            print(dataBrain.choiceAnswer)
            print("Go to Thank you page")
        }
    }
    


}
