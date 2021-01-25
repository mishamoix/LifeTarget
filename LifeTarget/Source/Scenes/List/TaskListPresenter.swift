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
	func startLoading()
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

		defer {
			DispatchQueue.mainAsyncIfNeeded {
				self.view?.updateLoader(hidden: true)
			}
		}

		if tasks.isEmpty {
			DispatchQueue.mainAsyncIfNeeded {
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

		DispatchQueue.mainAsyncIfNeeded {
			let viewModel = TaskListScene.ViewModel(parent: parentViewModel,
													tasks: viewModels, nestedLevel: nestedLevel + 1)
			self.view?.show(viewModel: viewModel)
		}
	}

	func displayTaskName(name: String) {
		DispatchQueue.mainAsyncIfNeeded {
			self.view?.setup(title: name)
		}
	}

	func displayMainTitle() {
		DispatchQueue.mainAsyncIfNeeded {
			self.view?.setup(title: "main_list_title".loc)
		}
	}

	func startLoading() {
		DispatchQueue.mainAsyncIfNeeded {
			self.view?.updateLoader(hidden: false)
		}
	}
}
