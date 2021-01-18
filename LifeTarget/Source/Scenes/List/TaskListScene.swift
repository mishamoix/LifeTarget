//
//  TaskListScene.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

enum TaskListScene {
	struct ViewModel {
		let tasks: [TaskViewModel]
	}

	enum ChangeType {
		case adding(parent: Task?)
		case change(task: Task)
	}
}
