//
//  App+JSON.swift
//  AppTests
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Quick
import Foundation

class JSON<T: Codable> {
    // Converts JSON File to codable model
    func load(fromFileName fileName: String) -> T? {
         guard let data = JSON.loadData(fileName) else {
             return nil
         }
        let jsonDecoder = JSONDecoder()
        let result = try! jsonDecoder.decode(T.self, from: data)
      
        return result
     }
    
    // Get json file from bundle
    static func loadData(_ fileName: String) -> Data! {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return nil
    }
    
    // Generic Error response
     static func Error(statusCode: Int) -> Error {
         let message = "System Error Message"
         let errorTemp = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: message as Any, NSLocalizedFailureReasonErrorKey: ""])
         return errorTemp
     }
}
