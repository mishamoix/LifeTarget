//
//  TaskListInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

protocol TaskListInteractionLogic {
	func start()

	func addNewTaskTapped()
}

final class TaskListInteractor {

	typealias Scene = TaskListScene

	private let router: TasksFlowable
	private let presenter: TaskListPresentationLogic

	init(router: TasksFlowable,
		 presenter: TaskListPresentationLogic) {
		self.router = router
		self.presenter = presenter
	}
}

// MARK: - TaskListInteractionLogic
extension TaskListInteractor: TaskListInteractionLogic {
	func start() {}

	func addNewTaskTapped() {
		router.openChangeTask(task: .adding(parent: nil))
	}
}
