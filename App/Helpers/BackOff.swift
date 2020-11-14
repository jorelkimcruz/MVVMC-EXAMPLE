//
//  BackOff.swift
//  App
//
//  Created by MAC HOME on 11/14/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation
class BackOff {
    
    // Exponential backoff
    // Gradually increase time between repeats
    // referrence: https://phelgo.com/exponential-backoff/
    
    static func getDelay(for n: Int) -> Int {
        let maxDelay = 300000 // 5 minutes
        let delay = Int(pow(2.0, Double(n))) * 1000
        let jitter = Int.random(in: 0...1000)
        return min(delay + jitter, maxDelay)
    }
    
    static func execute(on queue: DispatchQueue, retry: Int = 0, closure: @escaping () -> Void) {
        let delay = BackOff.getDelay(for: retry)
        queue.asyncAfter(
            deadline: DispatchTime.now() + .milliseconds(delay),
            execute: closure)
    }
}
