//
//  TaskListInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

protocol TaskListInteractionListener: AnyObject {
	func needUpdateParent()
}

protocol TaskListInteractionLogic {
	func start()
	func addNewTaskTapped()
	func editTaskTapped(task: Task)
	func subtasksTapped(task: Task)
	func plusTapped(task: Task)
	func completeTapped(task: Task)
}

final class TaskListInteractor {

	typealias Scene = TaskListScene

	private let router: TasksFlowable
	private let presenter: TaskListPresentationLogic
	private let taskProvider: TaskProviderProtocol

	private let parent: Task?
	private weak var listener: TaskListInteractionListener?
	private let nestedLevel: Int
	private let notificationService: NotificationServiceProtocol

	init(router: TasksFlowable,
		 presenter: TaskListPresentationLogic,
		 taskProvider: TaskProviderProtocol,
		 input: Scene.Input,
		 notificationService: NotificationServiceProtocol) {
		self.router = router
		self.presenter = presenter
		self.taskProvider = taskProvider
		self.parent = input.parent
		self.listener = input.listener
		self.nestedLevel = input.nestedLevel
		self.notificationService = notificationService
	}

	private func fetchTasks() {
		taskProvider.fetchTasks(with: parent) { [weak self] tasks in
			self?.presenter.show(tasks: tasks, parent: self?.parent)
		}
	}
}

// MARK: - TaskListInteractionLogic
extension TaskListInteractor: TaskListInteractionLogic {
	func start() {
		initialSetup()
		fetchTasks()
	}

	func addNewTaskTapped() {
		router.openChangeTask(task: .adding(parent: parent), listener: self)
	}

	func editTaskTapped(task: Task) {
		router.openChangeTask(task: .change(task: task), listener: self)
	}

	func subtasksTapped(task: Task) {
		router.openList(input: Scene.Input(nestedLevel: nestedLevel + 1, parent: task,
										   listener: self))
	}

	func plusTapped(task: Task) {
		var resultTask = task
		resultTask.progress?.current += 1

		taskProvider.save(task: resultTask, parent: resultTask.parent?.value) { [weak self] in
			self?.fetchTasks()
		}
	}

	func completeTapped(task: Task) {
		var resultTask = task
		resultTask.isCompleted = true
		taskProvider.save(task: resultTask, parent: resultTask.parent?.value) { [weak self] in
			self?.notificationService.update(action: .remove(id: resultTask.id))
			self?.needUpdateParent()
		}
	}
}

extension TaskListInteractor: ChangeTaskInteractionListener {
	func refreshTasks() {
		fetchTasks()
		listener?.needUpdateParent()
	}
}

extension TaskListInteractor: TaskListInteractionListener {
	func needUpdateParent() {
		fetchTasks()
		listener?.needUpdateParent()
	}
}

private extension TaskListInteractor {
	func initialSetup() {
		if nestedLevel == 0 {
			presenter.displayMainTitle()
		} else {
			presenter.displayNestedLevel(nestedLevel)
		}
	}
}
