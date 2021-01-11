//
//  TestDB.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 02.11.2020.
//

import CoreData

@objc(TestDB)
final class TestDB: NSManagedObject {
	@NSManaged public var message: String
	@NSManaged public var date: Date

	@discardableResult
	convenience init(message: String, context: NSManagedObjectContext) {
		let entity = context.entity(Self.self)
		self.init(entity: entity, insertInto: context)

		self.message = message
		self.date = Date()
	}
}
