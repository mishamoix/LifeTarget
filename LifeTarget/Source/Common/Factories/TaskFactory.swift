//
//  TaskFactory.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 18.01.2021.
//

import UIKit

protocol TaskFactoryProtocol {
	func buildTaskViewModel(with task: Task) -> TaskViewModel
	func buildTaskViewModels(with tasks: [Task]) -> [TaskViewModel]
}

final class TaskFactory: TaskFactoryProtocol {

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .none
		return formatter
	}()

	func buildTaskViewModel(with task: Task) -> TaskViewModel {
		return TaskViewModel(task: task,
							 progresses: buildProgresses(from: task),
							 subtasks: buildSubtasksLabel(task: task))
	}

	func buildTaskViewModels(with tasks: [Task]) -> [TaskViewModel] {
		tasks.map({ buildTaskViewModel(with: $0) })
	}
}

private extension TaskFactory {
	func buildProgresses(from task: Task) -> [ProgressViewModel] {
		var result: [ProgressViewModel] = []

		if let progress = task.progress {
			result.append(buildProgress(from: progress, task: task))
		}

		if let subtasks = task.subtasks, !subtasks.isEmpty {
			result.append(buildProgress(from: subtasks))
		}

		if let duration = task.duration, let durationResult = buildProgress(from: duration) {
			result.append(durationResult)
		}
		return result
	}

	func buildProgress(from progress: Task.Progress, task: Task) -> ProgressViewModel {
		let progressLabel = "activities_progress".loc + ": \(Int(progress.current))/\(Int(progress.maxCount))"
		let hasPlusButton = progress.current < progress.maxCount
		let prog = ProgressViewModel(color: Colors.progress,
									 progress: progress.current / progress.maxCount,
									 subtitle: progressLabel,
									 showPlus: !task.isCompleted && hasPlusButton)
		return prog
	}

	func buildProgress(from subtasks: [Task]) -> ProgressViewModel {

		let completedTasks = subtasks.filter({ $0.isCompleted }).count

		let prog = ProgressViewModel(color: Colors.accent,
									 progress: Float(completedTasks) / Float(subtasks.count),
									 subtitle: "subtasks".loc + ": \(completedTasks)/\(subtasks.count)",
									 showPlus: false)
		return prog
	}

	func buildProgress(from duration: Task.Duration) -> ProgressViewModel? {
		let calendar = Calendar.current

		let dateStart = calendar.startOfDay(for: duration.start)
		let dateEnd = calendar.startOfDay(for: duration.end)
		let currentDate = calendar.startOfDay(for: Date())

		let allDays = calendar.dateComponents([.day], from: dateStart, to: dateEnd).day ?? 0
		let pastDays = calendar.dateComponents([.day], from: dateStart, to: currentDate).day ?? 0

		if allDays == 0 {
			return nil
		}

		let progress: Float
		let title: String

		if dateStart > Date() {
			progress = 0
			title = "duration_will_start".loc + ": \(dateFormatter.string(from: duration.start))"
		} else {
			progress = Float(pastDays) / Float(allDays)
			title = "finish_date".loc
				+ ": \(dateFormatter.string(from: duration.end)), "
				+ "days_progress".loc
				+ ": \(pastDays)/\(allDays)"
		}

		let prog = ProgressViewModel(color: Colors.timeLeft, progress: progress,
									 subtitle: title, showPlus: false)
		return prog
	}

	func buildSubtasksLabel(task: Task) -> String? {
		if let subtasks = task.subtasks, !subtasks.isEmpty {
			var subtaskList = subtasks
				.lazy
				.prefix(3)
				.map(\.title)
				.map({ "\t• \($0)" })
				.joined(separator: "\n")

			if subtasks.count > 3 { subtaskList += "\n\t..." }

			return "subtasks".loc + ":\n" + subtaskList
		} else {
			return nil
		}
	}
}
