//
//  DataBrain.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/6.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import Foundation

struct LevelDataBrain {
    let levelQuestions = [
        LevelQuestions(question: "How are you feeling?"),
        LevelQuestions(question: "How much damage has Covid-19 caused to your life?"),
        LevelQuestions(question: "Example question:)")
    ]
    
    var currentLevelQuestion = 0
    var levelAnswer = [Float]()
    
    func getLevelQuestionText() -> String {
        //print(levelQuestions[currentLevelQuestion].lvlQuestion)
        return levelQuestions[currentLevelQuestion].lvlQuestion
    }
    
    mutating func getNextLevelQuestion() -> Bool {
        if currentLevelQuestion + 1 < levelQuestions.count {
            currentLevelQuestion += 1
            return true
        } else {
            currentLevelQuestion = 0
            return false
        }
    }
    
    func getLevelAnswer() -> [Float] {
//        for i in 0...(levelAnswer.count-1) {
//            
//        }
        return levelAnswer
    }
    
}
