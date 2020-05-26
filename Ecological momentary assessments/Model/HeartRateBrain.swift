//
//  HeartRateBrain.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/5/22.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import Foundation
import HealthKit

class HealthStore: HKHealthStore {
    
    func authorizeHealthKit() {
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        self.requestAuthorization(toShare: share, read: read) {(chk, error) in
            if (chk) {
                print("Permission granted!")
            }
        }
    }
    
    func fetchLatestHeartRate() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let predict = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        //sort the HR sample so the result[0] will be the newest heart rate
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predict, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) {(sample, result, error) in
            guard error == nil else {
                return
            }
            
            //fetch the latest HR data
            let data = result![0] as! HKQuantitySample
            let unit = HKUnit(from: "count/min")
            let latestHR = data.quantity.doubleValue(for: unit)
            print("Latest heart: \(latestHR) BPM")
            
            //print the HR time information
            let dataFormator = DateFormatter()
            dataFormator.dateFormat = "MM/dd/yyyy hh:mm s"
            let startDate = dataFormator.string(from: data.startDate)
            let endDate = dataFormator.string(from: data.endDate)
            print("Start Date: \(startDate) ; End Date: \(endDate)")
             
        }
        self.execute(query)
    }
}
