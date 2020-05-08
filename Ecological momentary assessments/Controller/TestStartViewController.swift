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

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuestion" {
            let destinationVC = segue.destination as! LvlQuestionViewController
            destinationVC.questionText = dataBrain.getLevelQuestionText()
        }
    }

}
