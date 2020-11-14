//
//  Storyboard.swift
//  App
//
//  Created by MAC HOME on 11/12/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit
// MARK: Available Storyboard (name)
enum Storyboard: String {
    case main = "Main"
}

protocol Storyboarded {
    static func instantiate(name: Storyboard) -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate(name: Storyboard) -> Self {
        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = self.className()
        
        // load our storyboard
        let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle.main)
        
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
    
    static func className() -> String {
        let fullName = NSStringFromClass(self)
        return fullName.className()
    }

}

extension String {
    fileprivate func className() -> String {
        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = self.components(separatedBy: ".")[1]
        return className
    }
}
