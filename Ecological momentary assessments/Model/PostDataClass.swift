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
    let name: [String]

    enum CodingKeys: String, CodingKey {
       // case userName = "userName"
        case hr, timestamp, name
    }
    
    init(hr: [Int], timestamp: [Double], name: [String]) {
        self.hr = hr
        self.timestamp = timestamp
        self.name = name
    }
}
