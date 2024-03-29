//
//  TasksFlow.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

protocol TasksFlowable {
	func openList(input: TaskListScene.Input)
	func openChangeTask(task: TaskListScene.ChangeType, listener: ChangeTaskInteractionListener)
}

final class TasksFlow {

	private let baseViewController: MainViewController
	private let baseNavigationViewController = NavigationController()
	private let taskProvider: TaskProviderProtocol
	private let notifications = NotificationService.shared

	private weak var rootListInteractor: TaskListInteractor?

	init(base viewController: MainViewController, db: DatabaseCoordinatorProtocol) {
		self.baseViewController = viewController
		self.taskProvider = TaskProvider(db: db)
	}

	func start() {
		let taskList = buildTaskList(input: TaskListScene.Input())
		baseNavigationViewController.setViewControllers([taskList], animated: false)
		baseViewController.add(viewController: baseNavigationViewController)
	}

	func refreshTaskList() {
		rootListInteractor?.refreshTasks()
	}

	private func buildTaskList(input: TaskListScene.Input) -> UIViewController {
		let presenter = TaskListPresenter(factory: TaskFactory())
		let interactor = TaskListInteractor(router: self, presenter: presenter,
											taskProvider: taskProvider, input: input,
											notificationService: notifications)
		let view = TaskListViewController(interactor: interactor)

		presenter.view = view

		rootListInteractor = interactor
		view.tabBarItem = UITabBarItem(title: "task_list".loc,
									   image: UIImage(named: "taskList"),
									   tag: 0)

		return view
	}

	private func buildChangeTask(task: TaskListScene.ChangeType,
								 listener: ChangeTaskInteractionListener) -> UIViewController {
		let presenter = ChangeTaskPresenter()
		let interactor = ChangeTaskInteractor(task: task.changeInput, router: self,
											  presenter: presenter, taskProvider: taskProvider,
											  notificationService: notifications,
											  listener: listener)
		let view = ChangeTaskViewController(interactor: interactor)

		presenter.view = view

		return view
	}
}

extension TasksFlow: TasksFlowable {
	func openChangeTask(task: TaskListScene.ChangeType, listener: ChangeTaskInteractionListener) {
		let view = buildChangeTask(task: task, listener: listener)
		baseNavigationViewController.present(NavigationController(rootViewController: view),
											 animated: true)
	}

	func openList(input: TaskListScene.Input) {
		let taskList = buildTaskList(input: input)
		baseNavigationViewController.pushViewController(taskList, animated: true)
	}
}
