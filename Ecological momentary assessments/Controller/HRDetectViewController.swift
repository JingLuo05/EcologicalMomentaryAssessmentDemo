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
    @IBOutlet weak var HRLabel: UILabel!
    @IBOutlet weak var HRViewLabel: UILabel!
    
    
    let healthStore = HealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityMarker.isHidden = true
        HRLabel.isHidden = true
        HRViewLabel.isHidden = true
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        startButton.isHidden = true
        self.activityMarker.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            self.healthStore.fetchLatestHeartRate()
            
            while self.healthStore.getCurrentHR() == 1 {
                // block the async fetch heart rate
            }
            
            self.activityMarker.isHidden = true
            self.HRViewLabel.isHidden = false
            self.HRLabel.text = " \(String(self.healthStore.getCurrentHR())) bps"
            self.HRLabel.isHidden = false
        }
    }
    
}
