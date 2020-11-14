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
    
    private let sourcesURL = URL(string: "https://api.github.com")!
    
    func getUserList(page: Int, completion : @escaping (Result<Data, Error>) -> ()){
        
        URLSession.shared.dataTask(with: URL(string:  "\(sourcesURL)/users?since=\(page)")!) { (data, urlResponse, error) in
            if let data = data {
                completion(.success(data))
                
            } else {
                completion(.failure(error!))
            }
        }.resume()
    }
    
    func getProfile(of username: String, completion : @escaping (Result<Data, Error>) -> ()) {
        log_error(message: "\(sourcesURL)/users/\(username)")
        URLSession.shared.dataTask(with: URL(string:  "\(sourcesURL)/users/\(username)")!) { (data, urlResponse, error) in
            if let data = data {
                completion(.success(data))
                
            } else {
                completion(.failure(error!))
            }
        }.resume()
    }
}
