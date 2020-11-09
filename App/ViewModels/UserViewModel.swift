//
//  UserViewModel.swift
//  App
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation
import CoreData

protocol UserViewModelDelegate: class {
    func userDataDidChange()
    func syncToPersistenDidFinish()
    func syncFromPersistenceDidFinish()
}

class UserViewModel {
    
    weak var delegate: UserViewModelDelegate?
    private var apiService : APIServiceProtocol!
    private var usermanagerStorage: UserStorageManger!
    
    private(set) var currentPage: Int = 0
    
    private(set) var userList : UserList! {
        didSet {
            self.delegate?.syncFromPersistenceDidFinish()
        }
    }
    
    private(set) var userData : Data! {
        didSet {
            self.delegate?.userDataDidChange()
        }
    }
    
    init(service: APIServiceProtocol, persistence: UserStorageManger) {
        self.apiService =  service
        self.usermanagerStorage = persistence
    }
    
    func requestUserListFromServer() {
        self.apiService.getUserList(page: currentPage) { [weak self] (resultData) in
            guard let `self` = self else {
                return
            }
            switch (resultData) {
            case .success(let data):
                self.userData = data
                self.currentPage += 1
            case .failure(let error):
                log_error(message: error.localizedDescription)
                break
            }
        }
    }
    
    func syncUserListToPersistence(data: Data) {
        let jsonDecoder = JSONDecoder()
        let managedObjectContext = usermanagerStorage.backgroundContext
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context else {
            fatalError("Failed to retrieve managed object context Key")
        }
        jsonDecoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        
        do {
            let _ = try jsonDecoder.decode(UserList.self, from: data)
            usermanagerStorage.save(with: managedObjectContext)
            self.delegate?.syncToPersistenDidFinish()
        } catch {
            log_error(message: error.localizedDescription)
            self.delegate?.syncToPersistenDidFinish()
        }
    }
    
    func getUserListFromPersistence() {
        let context = usermanagerStorage.mainContext
        let userFetchRequest = NSFetchRequest<User>(entityName: User.identifier)
        userFetchRequest.resultType = .managedObjectResultType
        
        do {
            self.userList = try context.fetch(userFetchRequest)
        }
        catch _ {
            fatalError("Failed to retrieve managed object result")
        }
    }
    
}
