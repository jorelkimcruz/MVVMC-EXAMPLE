//
//  MockHelper.swift
//  AppTests
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation

public enum Response: String {
    case success = "approved"
    case failed = "rejected"
    case systemError = "boarding"
}

class ServiceMock {
    let response: Response
    let responseFile: String?
    let errorResponseFile: String?
    let errorCode: Int?
    
    init(response: Response, responseFile: String?, errorResponseFile: String?, errorCode: Int? = nil) {
        self.response = response
        self.responseFile = responseFile
        self.errorResponseFile = errorResponseFile
        self.errorCode = errorCode
    }
}
