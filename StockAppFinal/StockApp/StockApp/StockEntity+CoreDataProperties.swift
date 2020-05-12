//
//  StockEntity+CoreDataProperties.swift
//  StockApp
//
//  Created by mcstonge on 11/13/18.
//  Copyright © 2018 mcstonge. All rights reserved.
//
//

import Foundation
import CoreData


extension StockEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockEntity> {
        return NSFetchRequest<StockEntity>(entityName: "StockEntity")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var ticker: String?

}
