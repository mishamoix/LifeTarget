//
//  NSManagedObjectContext+CRUD.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 02.11.2020.
//

import CoreData

extension NSManagedObjectContext {

	func entry<T: NSManagedObject>(entity: T.Type = T.self, predicate: NSPredicate? = nil) -> T? {
		entries(entity: entity, predicate: predicate).first
	}

	func entries<T: NSManagedObject>(entity: T.Type = T.self,
									 predicate: NSPredicate? = nil,
									 sort: NSSortDescriptor? = nil) -> [T] {
		let request = NSFetchRequest<T>()
		request.entity = self.entity(entity.self)
		request.predicate = predicate
		if let sort = sort {
			request.sortDescriptors = [sort]
		}

		do {
			return try fetch(request)
		} catch {
			fatalError("Fetch objects fail for \(entity): \(error)")
		}
	}

	func removeEntries(entity: AnyClass, predicate: NSPredicate? = nil) {
		let request = NSFetchRequest<NSFetchRequestResult>()
		request.entity = self.entity(entity.self)
		request.predicate = predicate

		let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

		do {
			_ = try execute(deleteRequest)
		} catch {
			fatalError("Delete objects fail for \(entity): \(error)")
		}
	}

	func remove<T: NSManagedObject>(entity: T) {
		delete(entity)
	}
}
