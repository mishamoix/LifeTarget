//
//  TasksFlow.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

protocol TasksFlowable {
	func openChangeTask(task: TaskListScene.ChangeType, listener: ChangeTaskInteractionListener)
}

final class TasksFlow {

	private let baseViewController: MainViewController
	private let baseNavigationViewController = NavigationController()
	private lazy var taskProvider = TaskProvider(db: DatabaseCoordinator(name: "Models"))

	init(base viewController: MainViewController) {
		self.baseViewController = viewController
	}

	func start() {
		let taskList = buildTaskList()
		baseNavigationViewController.setViewControllers([taskList], animated: false)
		baseViewController.add(viewController: baseNavigationViewController)
	}

	private func buildTaskList() -> UIViewController {
		let presenter = TaskListPresenter(factory: TaskFactory())
		let interactor = TaskListInteractor(router: self, presenter: presenter,
											taskProvider: taskProvider)
		let view = TaskListViewController(interactor: interactor)

		presenter.view = view

		view.tabBarItem = UITabBarItem(title: "task_list".loc,
									   image: UIImage(named: "taskList"),
									   tag: 0)

		return view
	}

	private func buildChangeTask(task: TaskListScene.ChangeType,
								 listener: ChangeTaskInteractionListener) -> UIViewController {
		let presenter = ChangeTaskPresenter()
		let interactor = ChangeTaskInteractor(task: task.changeInput, router: self,
											  presenter: presenter, taskProvider: taskProvider, listener: listener)
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
}