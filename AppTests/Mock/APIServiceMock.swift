//
//  APIServiceMock.swift
//  AppTests
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//
import Foundation
@testable import App

class APIServiceMock: ServiceMock, APIServiceProtocol {
    func getUserList(page: Int, completion: @escaping (Result<Data, Error>) -> ()) {
        switch response {
        case .success:
            completion(.success(JSON<UserList>.loadData(responseFile!)))
        case .failed:
            break
        default:
            completion(.failure(JSON<UserList>.Error(statusCode: errorCode!)))
            break
        }
    }
    
    
}
