//
//  ArticleEntity+CoreDataProperties.swift
//  AxxessCodeTestApp
//
//  Created by Shailesh Gole on 15/08/20.
//  Copyright © 2020 ShaileshG. All rights reserved.
//
//

import Foundation
import CoreData

extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: String?
    @NSManaged public var data: String?
    @NSManaged public var date: String?

}
