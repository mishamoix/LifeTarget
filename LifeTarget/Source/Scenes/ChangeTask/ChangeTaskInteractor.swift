//
//  ChangeTaskInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

protocol ChangeTaskInteractionListener: AnyObject {
	func refreshTasks()
}

protocol ChangeTaskInteractionLogic {

	func start()

	func saveTapped(with model: ChangeTaskScene.Model, viewController: UIViewController)
	func closeTapped(viewController: UIViewController)
}

final class ChangeTaskInteractor {

	typealias Scene = ChangeTaskScene

	private let router: TasksFlowable
	private let presenter: ChangeTaskPresentationLogic
	private let task: Scene.Input
	private let taskProvider: TaskProviderProtocol
	private weak var listener: ChangeTaskInteractionListener?

	init(task: Scene.Input,
		 router: TasksFlowable,
		 presenter: ChangeTaskPresentationLogic,
		 taskProvider: TaskProviderProtocol,
		 listener: ChangeTaskInteractionListener? = nil) {
		self.task = task
		self.router = router
		self.presenter = presenter
		self.taskProvider = taskProvider
		self.listener = listener
	}

	private func validate(model: ChangeTaskScene.Model) -> [String] {
		var errors: [String] = []

		if let err = model.duration?.validate() {
			errors.append(err)
		}

		if let err = model.progress?.validate() {
			errors.append(err)
		}

		if let err = model.exposition?.validate() {
			errors.append(err)
		}

		if model.exposition == nil {
			errors.append("empty_title".loc)
		}

		return errors
	}
}

// MARK: - ChangeTaskInteractionLogic
extension ChangeTaskInteractor: ChangeTaskInteractionLogic {

	func start() {
		switch task {
		case .adding:
			presenter.setupForNewTask()
		case .change(let task):
			presenter.setupForChange(task: task)
		}
	}

	func saveTapped(with model: ChangeTaskScene.Model, viewController: UIViewController) {
		let errors = validate(model: model)
		if !errors.isEmpty {
			let error = errors.map({ "- \($0)" }).joined(separator: "\n")
			presenter.showValidation(error: error)
			return
		}

		taskProvider.save(task: model.task) { [weak self] in
			self?.listener?.refreshTasks()
			DispatchQueue.main.async { [weak viewController] in
				viewController?.dismiss(animated: true, completion: nil)
			}
		}
	}

	func closeTapped(viewController: UIViewController) {
		viewController.dismiss(animated: true, completion: nil)
	}
}
