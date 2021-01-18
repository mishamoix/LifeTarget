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

	init(task: Task, progresses: [ProgressViewModel]) {
		self.task = task
		self.progresses = progresses

		if let subtasks = task.subtasks, !subtasks.isEmpty {
			var subtaskList = subtasks
				.lazy
				.prefix(3)
				.map(\.title)
				.map({ "\t• \($0)" })
				.joined(separator: "\n")

			if subtasks.count > 3 { subtaskList += "\n\t..." }

			self.subtasks = "subtasks".loc + ":\n" + subtaskList
		} else {
			self.subtasks = nil
		}
	}
}
