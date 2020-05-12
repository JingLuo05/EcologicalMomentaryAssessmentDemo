//
//  TestStartViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/7.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit

class TestStartViewController: UIViewController {
    var dataBrain = LevelDataBrain()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2243741453, green: 0.2615192533, blue: 0.4102925658, alpha: 1)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuestion" {
            let destinationVC = segue.destination as! LvlQuestionViewController
            destinationVC.questionText = dataBrain.getLevelQuestionText()
        }
    }

}
