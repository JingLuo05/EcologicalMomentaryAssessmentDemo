//
//  ChoiceDataBrain.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/7.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import Foundation

struct ChoiceDataBrain {
    let choiceQuestions = [
        ChoiceQuestion(question: "What have you been doing in the last 10 minutes?", option: ["Study", "Exercise", "Entertainment", "Work", "Sleep", "Eat"]),
        ChoiceQuestion(question: "Where are you?", option: ["Home", "Vehicle", "Restaurant/Bar", "Workspace", "Other's home", "Grocery store"]),
    ]
    
    var currentChoiceQuestion = 0
    var choiceAnswer = [String]()
    
    func getChoiceQuestionText() -> String {
        print(choiceQuestions[currentChoiceQuestion].choiceQuestion)
        return choiceQuestions[currentChoiceQuestion].choiceQuestion
    }
    
    func getQuestionOptions() -> [String] {
        return choiceQuestions[currentChoiceQuestion].choices
    }
    
    mutating func getNextChoiceQuestion() -> Bool {
        if currentChoiceQuestion + 1 < choiceQuestions.count {
            currentChoiceQuestion += 1
            return true
        } else {
            currentChoiceQuestion = 0
            return false
        }
    }
    
    func getChoiceAnswer() -> [String] {
        return choiceAnswer
    }
}
