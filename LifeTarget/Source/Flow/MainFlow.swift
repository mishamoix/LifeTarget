//
//  MainFlow.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 01.11.2020.
//

import UIKit

protocol MainFlowLogic { }

final class MainFlow {

	private(set) lazy var mainViewController: UIViewController = MainViewController()

	func startFlow() {
		let presenter = TaskListPresenter()
		let interactor = TaskListInteractor(router: self, presenter: presenter)
		let view = TaskListViewController(interactor: interactor)

		view.willMove(toParent: mainViewController)
		mainViewController.addChild(view)
		mainViewController.view.addSubview(view.view)
		view.view.frame = mainViewController.view.bounds
		view.didMove(toParent: mainViewController)
	}
}

extension MainFlow: MainFlowLogic {

}
