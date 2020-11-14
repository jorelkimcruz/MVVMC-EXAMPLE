//
//  ProfileViewModel.swift
//  App
//
//  Created by MAC HOME on 11/13/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation
import CoreData
protocol ProfileViewModelDelegate: class {
    func userDataDidChange()
    func userDidUpdate(user: User)
}
class ProfileViewModel {
    
    weak var delegate: ProfileViewModelDelegate?
    
    var selectedUser: User!
    private var apiService : APIServiceProtocol!
    private var usermanagerStorage: UserStorageManger!
    
    private(set) var profileData : Data! {
        didSet {
            self.delegate?.userDataDidChange()
        }
    }
    
    private var user : User!
    
    init(user: User, service: APIServiceProtocol, persistence: UserStorageManger) {
        self.apiService =  service
        self.usermanagerStorage = persistence
        self.selectedUser = user
    }
    
    func updateNotes(notes: String) {
        let context = usermanagerStorage.mainContext
        let userFetchRequest = NSFetchRequest<User>(entityName: User.identifier)
        userFetchRequest.predicate = NSPredicate(format: "id == %d", selectedUser.id)
        userFetchRequest.resultType = .managedObjectResultType
        do {
            let fetchResults = try context.fetch(userFetchRequest)
            if let profile = fetchResults.first {
                profile.note = notes
                log_success(message: "Updated: \(selectedUser.id)")
                try context.save()
                self.delegate?.userDidUpdate(user: profile)
            } else {
                log_error(message: "NO FETCH \(fetchResults)")
            }
        }
        catch _ {
            fatalError("Failed to retrieve managed object result")
        }
        
    }
    
    private func update(user: User) {
        let context = usermanagerStorage.mainContext
        let userFetchRequest = NSFetchRequest<User>(entityName: User.identifier)
        userFetchRequest.predicate = NSPredicate(format: "id == %d", selectedUser.id)
        userFetchRequest.resultType = .managedObjectResultType
        
        do {
            let fetchResults = try context.fetch(userFetchRequest)
            if let profile = fetchResults.first {
                profile.update(with: user)
                do {
                    try context.save()
                } catch {
                    log_error(message: "error save: \(error.localizedDescription)")
                }
                self.delegate?.userDidUpdate(user: profile)
            } else {
                log_error(message: "ERROR FETCH: \(fetchResults)")
            }
        }
        catch {
            fatalError("Failed to retrieve managed object result")
        }
    }
    
    func userExist() -> User? {
        let context = usermanagerStorage.mainContext
        let userFetchRequest = NSFetchRequest<User>(entityName: User.identifier)
        userFetchRequest.predicate = NSPredicate(format: "id == %d", selectedUser.id)
        userFetchRequest.resultType = .managedObjectResultType
        
        do {
            let fetchResults = try context.fetch(userFetchRequest)
            if let profile = fetchResults.first {
                return profile
            } else {
                log_error(message: "ERROR FETCH: \(fetchResults)")
            }
        }
        catch {
            fatalError("Failed to retrieve managed object result")
        }
        
        return nil
    }
    
    
    func requestProfile() {
        self.apiService.getProfile(of: selectedUser.login!) { [weak self] (resultData) in
            guard let `self` = self else {
                return
            }
            switch (resultData) {
            case .success(let data):
                log_success(message: "DONE")
                self.profileData = data
                break
            case .failure(let error):
                log_error(message: "Error: onFetch \(error.localizedDescription)")
                break
            }
        }
    }
    
    
    
    func syncUsersProfileToPersistence(data: Data) {
        let jsonDecoder = JSONDecoder()
        let managedObjectContext = usermanagerStorage.backgroundContext
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context else {
            fatalError("Failed to retrieve managed object context Key")
        }
        jsonDecoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        do {
            let user = try jsonDecoder.decode(User.self, from: data)
            update(user: user)
        } catch let error {
            log_error(message: "Error decode: \(error.localizedDescription)")
        }
    }
    
    func getUserProfileFromPersistence() {
        let context = usermanagerStorage.mainContext
        let userFetchRequest = NSFetchRequest<User>(entityName: User.identifier)
        userFetchRequest.predicate = NSPredicate(format: "id == %d", selectedUser.id)
        userFetchRequest.resultType = .managedObjectResultType
        
        do {
            if let user = try context.fetch(userFetchRequest).first {
                self.delegate?.userDidUpdate(user: user)
            }
        }
        catch _ {
            fatalError("Failed to retrieve managed object result")
        }
    }
}
