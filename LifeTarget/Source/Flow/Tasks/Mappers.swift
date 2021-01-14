//
//  Mappers.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

extension TaskListScene.ChangeType {
	var changeInput: ChangeTaskScene.Input {
		switch self {
		case .adding(let parent):
			return .adding(parent: parent)
		case .change(let task):
			return .change(task: task)
		}
	}
}
