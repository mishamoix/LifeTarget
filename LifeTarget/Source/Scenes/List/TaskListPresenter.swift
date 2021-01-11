//
//  TaskListPresenter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

protocol TaskListPresentationLogic {}

final class TaskListPresenter {

	typealias Scene = TaskListScene

	weak var view: TaskListDisplayLogic?
}

extension TaskListPresenter: TaskListPresentationLogic {}
