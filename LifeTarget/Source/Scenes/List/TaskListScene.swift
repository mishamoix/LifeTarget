//
//  TaskListScene.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

enum TaskListScene {

	struct Input {}

	struct Output {}

	struct Model {}

	struct Request {}

	struct Response {}

	struct ViewModel {}

	enum ChangeType {
		case adding(parent: Task?)
		case change(task: Task)
	}
}
