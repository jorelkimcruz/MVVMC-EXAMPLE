//
//  CodingUserInfoKey+Util.swift
//  App
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation
public extension CodingUserInfoKey {
  // Helper property to retrieve the Core Data managed object context
  static let context = CodingUserInfoKey(rawValue: "context")
}
