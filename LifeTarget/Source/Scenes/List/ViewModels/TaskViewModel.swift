//
//  TaskViewModel.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 18.01.2021.
//

import UIKit

struct TaskViewModel {

	let task: Task
	let progresses: [ProgressViewModel]
	let subtasks: String?

	var title: String {
		if task.isCompleted {
			return "✅ " + task.title
		}

		return task.title
	}

	init(task: Task, progresses: [ProgressViewModel], subtasks: String?) {
		self.task = task
		self.progresses = progresses
		self.subtasks = subtasks
	}
}
