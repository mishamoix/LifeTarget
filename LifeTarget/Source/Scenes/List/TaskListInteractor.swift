//
//  TaskListInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

protocol TaskListInteractionLogic {
	func start()
	func addNewTaskTapped()
	func editTaskTapped(task: Task)
}

final class TaskListInteractor {

	typealias Scene = TaskListScene

	private let router: TasksFlowable
	private let presenter: TaskListPresentationLogic
	private let taskProvider: TaskProviderProtocol
	private let input: Scene.Input

	init(router: TasksFlowable,
		 presenter: TaskListPresentationLogic,
		 taskProvider: TaskProviderProtocol,
		 input: Scene.Input) {
		self.router = router
		self.presenter = presenter
		self.taskProvider = taskProvider
		self.input = input
	}

	func fetchTasks() {
		taskProvider.fetchTasks(with: nil) { [weak self] tasks in
			self?.presenter.show(tasks: tasks)
		}
	}
}

// MARK: - TaskListInteractionLogic
extension TaskListInteractor: TaskListInteractionLogic {
	func start() {
		fetchTasks()
	}

	func addNewTaskTapped() {
		router.openChangeTask(task: .adding(parent: nil), listener: self)
	}

	func editTaskTapped(task: Task) {
		router.openChangeTask(task: .change(task: task), listener: self)
	}
}

extension TaskListInteractor: ChangeTaskInteractionListener {
	func refreshTasks() {
		fetchTasks()
	}
}
