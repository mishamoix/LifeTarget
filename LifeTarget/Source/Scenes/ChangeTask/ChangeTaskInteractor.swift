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
	func removeTapped(viewController: UIViewController)
}

final class ChangeTaskInteractor {

	typealias Scene = ChangeTaskScene

	private let router: TasksFlowable
	private let presenter: ChangeTaskPresentationLogic
	private let task: Scene.Input
	private let taskProvider: TaskProviderProtocol
	private weak var listener: ChangeTaskInteractionListener?
	private let notificationService: NotificationServiceProtocol

	init(task: Scene.Input,
		 router: TasksFlowable,
		 presenter: ChangeTaskPresentationLogic,
		 taskProvider: TaskProviderProtocol,
		 notificationService: NotificationServiceProtocol,
		 listener: ChangeTaskInteractionListener? = nil) {
		self.task = task
		self.router = router
		self.presenter = presenter
		self.taskProvider = taskProvider
		self.notificationService = notificationService
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

	private func updateNotification(with task: Task) {
		if let notification = task.notification, !task.isCompleted {
			notificationService.update(action: .add(id: task.id, notification: notification,
													title: "lets_start_work_notification".loc,
													message: "task".loc + ": \(task.title)"))
		} else {
			notificationService.update(action: .remove(id: task.id))
		}
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

		var resultTask: Task
		var parentTask: Task?

		switch task {
			case .change(let changingTask):
				resultTask = changingTask
				resultTask.progress = model.progress?.progress
				resultTask.duration = model.duration?.duration
				resultTask.title = model.exposition?.title ?? resultTask.title
				resultTask.exposition = model.exposition?.subtitle
				resultTask.isCompleted = model.isCompleted
				resultTask.notification = model.notification?.notification
				parentTask = changingTask.parent?.value
			case .adding(let parent):
				resultTask = model.task
				parentTask = parent
		}

		taskProvider.save(task: resultTask, parent: parentTask) { [weak self] in
			self?.listener?.refreshTasks()
			DispatchQueue.main.async { [weak viewController] in
				viewController?.dismiss(animated: true, completion: nil)
			}
		}

		updateNotification(with: resultTask)
	}

	func closeTapped(viewController: UIViewController) {
		viewController.dismiss(animated: true, completion: nil)
	}

	func removeTapped(viewController: UIViewController) {
		if case let Scene.Input.change(resultTask) = task {
			taskProvider.delete(task: resultTask) { [weak self] in
				self?.listener?.refreshTasks()
				DispatchQueue.main.async { [weak viewController] in
					viewController?.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
}
