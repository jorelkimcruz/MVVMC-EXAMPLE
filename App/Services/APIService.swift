//
//  APIService.swift
//  App
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//
import Foundation

protocol APIServiceProtocol {
    func getUserList(page: Int, completion : @escaping (Result<Data, Error>) -> ())
    func getProfile(of username: String, completion : @escaping (Result<Data, Error>) -> ())
}

class APIService: APIServiceProtocol {
    let serialQueue = DispatchQueue(label: "api.request.queue", qos: .background)
    private let sourcesURL = URL(string: "https://api.github.com")!
    
    func getUserList(page: Int, completion : @escaping (Result<Data, Error>) -> ()){
        log_success(message: "\(sourcesURL)/users?since=\(page)")
        serialQueue.async {
            URLSession.shared.dataTask(with: URL(string: "\(self.sourcesURL)/users?since=\(page)")!) { (data, urlResponse, error) in
                if let data = data {
                    completion(.success(data))
                    
                } else {
                    completion(.failure(error!))
                }
            }.resume()
        }
   
    }
    
    func getProfile(of username: String, completion : @escaping (Result<Data, Error>) -> ()) {
        log_error(message: "\(sourcesURL)/users/\(username)")
        serialQueue.async {
            URLSession.shared.dataTask(with: URL(string:  "\(self.sourcesURL)/users/\(username)")!) { (data, urlResponse, error) in
                if let data = data {
                    completion(.success(data))
                    
                } else {
                    completion(.failure(error!))
                }
            }.resume()
        }
    }
}
