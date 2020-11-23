//
//  PostDataClass.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/11/17.
//  Copyright © 2020 Jing Luo. All rights reserved.
//
// A class to store JSON data

import Foundation

class Post: Codable {
    //let id: Int
    //let userName: String
    let timestamp: [Double]
    let hr: [Int]

    enum CodingKeys: String, CodingKey {
       // case userName = "userName"
        case hr, timestamp
    }

//    init(userName: String, id: Int, hr: [Double], timestamp: [Double]) {
//        self.userName = userName
//        self.id = id
//        self.hr = hr
//        self.timestamp = timestamp
//    }
    
    init(hr: [Int], timestamp: [Double]) {
        self.hr = hr
        self.timestamp = timestamp
    }
}
