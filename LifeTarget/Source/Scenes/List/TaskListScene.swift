//
//  TaskListScene.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

enum TaskListScene {
	struct ViewModel {
		let parent: TaskViewModel?
		let tasks: [TaskViewModel]
		let nestedLevel: Int

		var hasParent: Bool {
			return parent != nil
		}

		var parentSubtitle: String {
			"nested_level".loc + ": \(nestedLevel)"
		}
	}

	enum ChangeType {
		case adding(parent: Task?)
		case change(task: Task)
	}

	struct Input {
		let parent: Task?
		let listener: TaskListInteractionListener?
		let nestedLevel: Int

		init(nestedLevel: Int = 0, parent: Task? = nil, listener: TaskListInteractionListener? = nil) {
			self.parent = parent
			self.listener = listener
			self.nestedLevel = nestedLevel
		}
	}
}
