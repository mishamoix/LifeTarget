//
//  ChangeTaskInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

protocol ChangeTaskInteractionLogic {

	func start()
}

final class ChangeTaskInteractor {

	typealias Scene = ChangeTaskScene

	private let router: TasksFlowable
	private let presenter: ChangeTaskPresentationLogic
	private let task: Scene.Input

	init(task: Scene.Input,
		 router: TasksFlowable,
		 presenter: ChangeTaskPresentationLogic) {
		self.task = task
		self.router = router
		self.presenter = presenter
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
}
