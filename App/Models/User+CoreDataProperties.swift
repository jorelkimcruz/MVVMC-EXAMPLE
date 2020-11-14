//
//  User+CoreDataProperties.swift
//  
//
//  Created by MAC HOME on 11/8/20.
//
//

import Foundation
import CoreData

extension User {
    
    @NSManaged public var id: Int16
    @NSManaged public var followers: Int16
    @NSManaged public var following: Int16
    @NSManaged public var login: String?
    @NSManaged public var name: String?
    @NSManaged public var company: String?
    @NSManaged public var blog: String?
    @NSManaged public var note: String?
    @NSManaged public var avatarURL: URL?
    @NSManaged public var url: URL?
    
    
}
