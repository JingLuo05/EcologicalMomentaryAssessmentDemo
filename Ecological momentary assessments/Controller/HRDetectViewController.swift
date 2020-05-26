//
//  HRDetectViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/21.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit
import HealthKit

class HRDetectViewController: UIViewController {


    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var activityMarker: UIActivityIndicatorView!
    
    let healthStore = HealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityMarker.isHidden = true
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        startButton.isHidden = true
        self.activityMarker.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.activityMarker.isHidden = true
            
            self.healthStore.fetchLatestHeartRate()
        }
    }
    
}
