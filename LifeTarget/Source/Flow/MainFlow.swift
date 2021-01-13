//
//  MainFlow.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 01.11.2020.
//

import UIKit

protocol MainFlowLogic { }

final class MainFlow {

	private(set) lazy var mainViewController = MainViewController()

	func startFlow() {
		mainViewController.add(viewController: buildNavigation(with: buildTaskList()))
		mainViewController.add(viewController: buildNavigation(with: buildSettings()))
	}

	private func buildTaskList() -> UIViewController {
		let presenter = TaskListPresenter()
		let interactor = TaskListInteractor(router: self, presenter: presenter)
		let view = TaskListViewController(interactor: interactor)

		view.tabBarItem = UITabBarItem(title: "task_list".loc,
									   image: UIImage(named: "taskList"),
									   tag: 0)

		return view
	}

	private func buildNavigation(with root: UIViewController) -> UINavigationController {
		return NavigationController(rootViewController: root)
	}

	private func buildSettings() -> UIViewController {
		let presenter = SettingsPresenter()
		let interactor = SettingsInteractor(router: self, presenter: presenter)
		let view = SettingsViewController(interactor: interactor)

		view.tabBarItem = UITabBarItem(title: "settings".loc, image: UIImage(named: "settings"), tag: 1)

		return view
	}
}

extension MainFlow: MainFlowLogic {

}
