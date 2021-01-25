//
//  TaskListPresenter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import Foundation

protocol TaskListPresentationLogic {
	func displayTaskName(name: String)
	func displayMainTitle()
	func show(tasks: [Task], parent: Task?, nestedLevel: Int)
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
	func show(tasks: [Task], parent: Task?, nestedLevel: Int) {
		if tasks.isEmpty {
			DispatchQueue.main.async {
				self.view?.showEmptyScreen()
			}
			return
		}

		let viewModels = factory.buildTaskViewModels(with: tasks)
		let parentViewModel: TaskViewModel?
		if let parent = parent {
			parentViewModel = factory.buildTaskViewModel(with: parent)
		} else {
			parentViewModel = nil
		}

		DispatchQueue.main.async {
			let viewModel = TaskListScene.ViewModel(parent: parentViewModel,
													tasks: viewModels, nestedLevel: nestedLevel + 1)
			self.view?.show(viewModel: viewModel)
		}
	}

	func displayTaskName(name: String) {
		DispatchQueue.main.async {
			self.view?.setup(title: name)
		}
	}

	func displayMainTitle() {
		DispatchQueue.main.async {
			self.view?.setup(title: "main_list_title".loc)
		}
	}
}
