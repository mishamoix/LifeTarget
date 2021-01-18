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

	init(task: Task, progresses: [ProgressViewModel]) {
		self.task = task
		self.progresses = progresses
	}
}
