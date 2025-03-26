//
//  Product+CoreDataProperties.swift
//  A2_iOS_Cheng_101362082
//
//  Created by Heather Shi on 2025-03-25.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productDescription: String?
    @NSManaged public var productID: Int64
    @NSManaged public var productName: String?
    @NSManaged public var productPrice: NSDecimalNumber?
    @NSManaged public var productProvider: String?

}

extension Product : Identifiable {

}
