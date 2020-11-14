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
            try container.encodeIfPresent(name, forKey: .name)
            
            try container.encodeIfPresent(blog, forKey: .name)
            try container.encodeIfPresent(company, forKey: .name)
            try container.encodeIfPresent(followers, forKey: .followers)
            try container.encodeIfPresent(following, forKey: .following)
            try container.encodeIfPresent(note, forKey: .note)
        } catch {
            log_error(message: "Error encode: \(error.localizedDescription)")
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
            login = try values.decodeIfPresent(String.self, forKey: .login)
            id = try values.decode(Int16.self, forKey: .id)
            avatarURL = try values.decodeIfPresent(URL.self, forKey: .avatarURL)
            url = try values.decodeIfPresent(URL.self, forKey: .url)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            company = try values.decodeIfPresent(String.self, forKey: .company)
            blog = try values.decodeIfPresent(String.self, forKey: .blog)
            followers = try values.decode(Int16.self, forKey: .followers)
            following = try values.decode(Int16.self, forKey: .following)
            note = try values.decodeIfPresent(String.self, forKey: .note)
        } catch {
            log_error(message: "Error decoder: \(error.localizedDescription)")
        }
        
    }
    
    func update(with user: User) {
        self.name = user.name
        self.avatarURL = user.avatarURL
        self.blog = user.blog
        self.company = user.company
        self.followers = user.followers
        self.following = user.following
        self.id = user.id
        self.login = user.login
        self.url = user.url
    }
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
        case url
        case profile
        case name
        case company
        case blog
        case followers
        case following
        case note
        case identifier
    }
}
