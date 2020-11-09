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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int16
    @NSManaged public var login: String?
    @NSManaged public var avatarURL: URL?
    @NSManaged public var url: URL?

}
