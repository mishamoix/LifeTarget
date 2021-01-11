//
//  TaskListInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

protocol TaskListInteractionLogic {

	func start()
}

final class TaskListInteractor {

	typealias Scene = TaskListScene

	private let router: MainFlowLogic
	private let presenter: TaskListPresentationLogic

	init(router: MainFlowLogic,
		 presenter: TaskListPresentationLogic) {
		self.router = router
		self.presenter = presenter
	}
}

// MARK: - TaskListInteractionLogic
extension TaskListInteractor: TaskListInteractionLogic {

	func start() {}
}
