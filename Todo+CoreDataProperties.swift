//
//  Todo+CoreDataProperties.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/20.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var modifyDate: Date?
    @NSManaged public var title: String?

}

extension Todo : Identifiable {

}
