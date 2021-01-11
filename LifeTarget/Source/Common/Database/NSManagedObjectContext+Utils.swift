//
//  NSManagedObjectContext+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 02.11.2020.
//

import CoreData

extension NSManagedObjectContext {
	func entity(_ objectClass: AnyClass) -> NSEntityDescription {
		guard
			let result = NSEntityDescription.entity(forEntityName: String(describing: objectClass), in: self)
			else {
			fatalError("Can't create entity for \(String(describing: objectClass))")
		}

		return result
	}
}
