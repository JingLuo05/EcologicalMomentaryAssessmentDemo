//
//  Data.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/6.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import Foundation

//Level questions have 1 Float answer
struct LevelQuestions {
    let lvlQuestion: String
    
    init(question: String) {
        lvlQuestion = question
    }
}


//Choice questions have 6 options and 1 Int answer
struct ChoiceQuestion {
    let choiceQuestion: String
    let choices: [String]
    
    init(question: String, option: [String]) {
        choiceQuestion = question
        choices = option
    }
}
