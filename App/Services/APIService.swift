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
}

class APIService: APIServiceProtocol {
    
    private let sourcesURL = URL(string: "https://api.github.com")!
    
    func getUserList(page: Int, completion : @escaping (Result<Data, Error>) -> ()){
        
        log_success(message:   "\(sourcesURL)/users?since=\(page)")
        URLSession.shared.dataTask(with: URL(string:  "\(sourcesURL)/users?since=\(page)")!) { (data, urlResponse, error) in
            if let data = data {
                completion(.success(data))
                
            } else {
                completion(.failure(error!))
            }
        }.resume()
    }
}
