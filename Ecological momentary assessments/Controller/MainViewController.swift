//
//  ViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/4.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit
import HealthKit

class MainViewController: UIViewController {
    
    let healthStore = HealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2243741453, green: 0.2615192533, blue: 0.4102925658, alpha: 1)
        
        healthStore.authorizeHealthKit()
    }
    
}

