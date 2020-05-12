//
//  UserEntity+CoreDataProperties.swift
//  StockApp
//
//  Created by mcstonge on 11/8/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var apiKey: String?

}
