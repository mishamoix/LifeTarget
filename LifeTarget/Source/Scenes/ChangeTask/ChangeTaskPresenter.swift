//
//  ChangeTaskPresenter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

protocol ChangeTaskPresentationLogic {
	func setupForNewTask()
	func setupForChange(task: Task)
	func showValidation(error: String)
}

final class ChangeTaskPresenter {

	typealias Scene = ChangeTaskScene

	weak var view: ChangeTaskDisplayLogic?
}

extension ChangeTaskPresenter: ChangeTaskPresentationLogic {
	func setupForNewTask() {
		let model = Scene.SetupViewModel(title: "new_task".loc, saveButtonString: "save".loc,
										 cancelButtonString: "cancel".loc, task: nil, isModify: false)
		view?.setup(with: model)
	}

	func setupForChange(task: Task) {
		let model = Scene.SetupViewModel(title: "change_task".loc, saveButtonString: "save".loc,
										 cancelButtonString: "cancel".loc, task: task, isModify: true)
		view?.setup(with: model)
	}

	func showValidation(error: String) {
		view?.show(error: ChangeTaskScene.ErrorModel(title: "validation_error_title".loc, message: error))
	}
}
