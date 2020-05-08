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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
