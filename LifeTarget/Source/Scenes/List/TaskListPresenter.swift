//
//  TaskListPresenter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import Foundation

protocol TaskListPresentationLogic {
	func displayNestedLevel(_ level: Int)
	func displayMainTitle()
	func show(tasks: [Task], parent: Task?)
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
	func show(tasks: [Task], parent: Task?) {
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
			self.view?.show(viewModel: TaskListScene.ViewModel(parent: parentViewModel, tasks: viewModels))
		}
	}

	func displayNestedLevel(_ level: Int) {
		DispatchQueue.main.async {
			let resultLevel = level + 1
			let title = "nested_level".loc + ": \(resultLevel)"
			self.view?.setup(title: title)
		}
	}

	func displayMainTitle() {
		DispatchQueue.main.async {
			self.view?.setup(title: "main_list_title".loc)
		}
	}
}
