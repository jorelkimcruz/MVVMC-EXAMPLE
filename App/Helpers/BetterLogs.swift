//
//  BetterLogs.swift
//  App
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation

func log_Warning(message: String) {
    print("⚠️ - \(message)")
}

func log_error(message: String) {
    print("🛑 - \(message)")
}

func log_success(message: String) {
    print("✅ - \(message)")
}
func log_fatal_error(message: String) {
    print("🛑 - FATAL ERROR!")
    fatalError(message)
}
