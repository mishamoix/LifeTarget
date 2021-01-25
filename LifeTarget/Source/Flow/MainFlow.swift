//
//  MainFlow.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 01.11.2020.
//

import UIKit

protocol MainFlowLogic {
}

final class MainFlow {

	private(set) lazy var mainViewController = MainViewController()
	private lazy var tasksFlow = TasksFlow(base: mainViewController)

	private let themeService: ThemeServiceProtocol

	init(themeService: ThemeServiceProtocol) {
		self.themeService = themeService
	}

	func startFlow() {
		tasksFlow.start()
		mainViewController.add(viewController: buildNavigation(with: buildSettings()))
	}

	private func buildNavigation(with root: UIViewController) -> UINavigationController {
		return NavigationController(rootViewController: root)
	}

	private func buildSettings() -> UIViewController {
		let presenter = SettingsPresenter()
		let interactor = SettingsInteractor(router: self, presenter: presenter,
											themeService: themeService)
		let view = SettingsViewController(interactor: interactor)
		presenter.view = view

		view.tabBarItem = UITabBarItem(title: "settings".loc, image: UIImage(named: "settings"), tag: 1)

		return view
	}
}

extension MainFlow: MainFlowLogic { }
