//
//  Queue.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/7/4.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

//Implement Queue structure
class Queue<T> {
    private var elements: [T] = []
    
    func enqueue(_ value: T) {
        elements.append(value)
    }
    
    func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    var count: Int {
        return elements.count
    }
    
    var head: T? {
        return elements.first
    }
    
    var tail: T? {
        return elements.last
    }
}
