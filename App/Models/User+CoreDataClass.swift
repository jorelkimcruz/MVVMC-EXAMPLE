//
//  User+CoreDataClass.swift
//  
//
//  Created by MAC HOME on 11/8/20.
//
//

import Foundation
import CoreData

// MARK: - GITHub User list
typealias UserList = [User]

public class User: NSManagedObject, Codable {
    static let identifier = "User"
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
            try container.encode(login, forKey: .login)
            try container.encode(avatarURL, forKey: .avatarURL)
            try container.encode(url, forKey: .url)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context
            else {
                fatalError("decode failure")
        }
        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError()
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: User.identifier, in: managedObjectContext) else {
            fatalError()
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            login = try values.decode(String.self, forKey: .login)
            id = try values.decode(Int16.self, forKey: .id)
            avatarURL = try values.decodeIfPresent(URL.self, forKey: .avatarURL)
            url = try values.decodeIfPresent(URL.self, forKey: .url)
            
        } catch {
            print ("error")
        }
        
    }
    
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
        case url
    }
}
