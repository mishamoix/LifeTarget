//
//  Task.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import Foundation

class Wrapper<T> {
	let value: T?

	init(_ value: T?) {
		self.value = value
	}
}

struct Task: IdentifiableInput {
	struct Duration: Equatable {
		var start: Date
		var end: Date
	}

	struct Progress: Equatable {
		var maxCount: Float
		var current: Float
	}

	var id: String = UUID().uuidString

	var title: String
	var exposition: String?

	var progress: Progress?
	var duration: Duration?
	var notification: PushNotification?

	var isCompleted: Bool

	var createDate: Date
	var updateDate: Date

	var subtasks: [Task]?
	var parent: Wrapper<Task>?

	var isLeaf: Bool {
		return false
	}

	var isRoot: Bool {
		return false
	}
}

extension Task: Hashable, Equatable {

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	static func == (lhs: Self, rhs: Self) -> Bool {
		if lhs.hashValue != rhs.hashValue {
			return false
		}

		let result = lhs.id == rhs.id &&
			lhs.title == rhs.title &&
			lhs.exposition == rhs.exposition &&
			lhs.progress == rhs.progress &&
			lhs.duration == rhs.duration &&
			lhs.notification == rhs.notification &&
			lhs.isCompleted == rhs.isCompleted

		return result
	}
}
