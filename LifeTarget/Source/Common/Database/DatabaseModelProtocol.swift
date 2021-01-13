//
//  DatabaseModelProtocol.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 13.01.2021.
//

import CoreData

protocol BasePredicatableInput {
	var basePredicate: NSPredicate { get }
}

protocol IdentifiableInput: BasePredicatableInput {
	var id: String { get }
}

extension IdentifiableInput {
	var basePredicate: NSPredicate {
		NSPredicate(format: "id = '\(self.id)'")
	}
}

protocol DatabaseModelProtocol {
	associatedtype Input: BasePredicatableInput

	@discardableResult
	static func createOrUpdate(input: Input, context: NSManagedObjectContext) -> Self

	func update(with model: Input)
}

extension DatabaseModelProtocol where Self: NSManagedObject {

	@discardableResult
	static func createOrUpdate(input: Input, context: NSManagedObjectContext) -> Self {
		let predicate = input.basePredicate

		let result = context.entry(entity: Self.self,
								   predicate: predicate) ?? Self(context: context)
		result.update(with: input)
		return result
	}

	@discardableResult
	static func createOrUpdate(input: Input, context: NSManagedObjectContext, update: (Self) -> Void) -> Self {
		let result = createOrUpdate(input: input, context: context)
		update(result)
		return result
	}
}
