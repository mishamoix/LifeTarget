//
//  TaskProvider.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 15.01.2021.
//

import CoreData

protocol TaskProviderProtocol {

	func save(task: Task, parent: Task?, completion: @escaping () -> Void)
	func delete(task: Task, completion: @escaping () -> Void)
	func fetchTasks(with parent: Task?, result: @escaping ([Task]) -> Void)
}

final class TaskProvider {

	private let db: DatabaseCoordinatorProtocol

	private var readContext: NSManagedObjectContext {
		if let read = db.readContext {
			return read
		}

		fatalError("DB has not read context")
	}

	private var writeContext: NSManagedObjectContext {
		if let write = db.writeContext {
			return write
		}

		fatalError("DB has not write context")
	}

	init(db: DatabaseCoordinatorProtocol) {
		self.db = db
	}
}

extension TaskProvider: TaskProviderProtocol {
	func save(task: Task, parent: Task?, completion: @escaping () -> Void) {
		let parentTask: TaskDB?
		if let parent = parent {
			parentTask = self.writeContext.entry(entity: TaskDB.self,
												 predicate: parent.basePredicate)
		} else {
			parentTask = nil
		}

		TaskDB.createOrUpdate(input: task, context: writeContext) { task in
			task.parent = parentTask
		}
		writeContext.perform { [weak self] in
			try? self?.writeContext.save()
			completion()
		}

	}

	func delete(task: Task, completion: @escaping () -> Void) {
		writeContext.perform { [weak self] in
			self?.writeContext.removeEntries(entity: TaskDB.self, predicate: task.basePredicate)
			completion()
		}
	}

	func fetchTasks(with parent: Task?, result: @escaping ([Task]) -> Void) {
		readContext.perform { [weak self] in

			let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: true)

			let entries: [TaskDB]?

			if let parent = parent {
				let predicate = NSPredicate(format: "parent.id = '\(parent.id)'")
				entries = self?.readContext.entries(entity: TaskDB.self, predicate: predicate,
													sort: sortDescriptor)

			} else {
				let predicate = NSPredicate(format: "parent = nil")
				entries = self?.readContext.entries(entity: TaskDB.self, predicate: predicate,
													sort: sortDescriptor)
			}
			guard let tasksDB = entries else {
				return result([])
			}

			let tasks = tasksDB.map({ Task(db: $0) })
			return result(tasks)
		}
	}
}
