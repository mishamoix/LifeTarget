//
//  TaskListPresenter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import Foundation

protocol TaskListPresentationLogic {
	func show(tasks: [Task])
}

final class TaskListPresenter {

	typealias Scene = TaskListScene

	weak var view: TaskListDisplayLogic?

	private let factory: TaskFactoryProtocol

	init(factory: TaskFactoryProtocol) {
		self.factory = factory
	}
}

extension TaskListPresenter: TaskListPresentationLogic {
	func show(tasks: [Task]) {
		if tasks.isEmpty {
			view?.showEmptyScreen()
			return
		}

		let viewModels = factory.buildTaskViewModels(with: tasks)
		DispatchQueue.main.async {
			self.view?.show(viewModel: TaskListScene.ViewModel(tasks: viewModels))
		}
	}
}
