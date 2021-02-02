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

	private let notificationExactDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}()

	private let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}()

	private let weekdayModel = WeekdayModel()

	func buildTaskViewModel(with task: Task) -> TaskViewModel {
		return TaskViewModel(task: task,
							 progresses: buildProgresses(from: task),
							 subtasks: buildSubtasksLabel(task: task),
							 notificationString: buildNotificationString(task))
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

		if let duration = task.duration, let durationResult = buildProgress(from: duration), !task.isCompleted {
			result.append(durationResult)
		}
		return result
	}

	func buildProgress(from progress: Task.Progress, task: Task) -> ProgressViewModel {
		let progressLabel = "activities_progress".loc + ": \(progress.current)/\(progress.maxCount)"
		let hasPlusButton = progress.current < progress.maxCount
		let prog = ProgressViewModel(color: Colors.progress,
									 progress: Float(progress.current) / Float(progress.maxCount),
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
				.map({ model -> String in
					var result = model.title
					if let progress = model.progress {
						result += " [\(progress.current)/\(progress.maxCount)]"
					}
					return result
				})
				.map({ "\t• \($0)" })
				.joined(separator: "\n")

			if subtasks.count > 3 { subtaskList += "\n\t..." }

			return "subtasks".loc + ":\n" + subtaskList
		} else {
			return nil
		}
	}

	func buildNotificationString(_ task: Task) -> String? {
		guard !task.isCompleted else { return nil }

		if let exactDate = task.notification?.date, exactDate > Date() {
			return "🔔 "
				+ "notification".loc
				+ ": \(notificationExactDateFormatter.string(from: exactDate))"
		} else if let weekdays = task.notification?.weekdays,
				  let time = task.notification?.dayTime?.date {
			let weekdaysString = weekdays.compactMap({ weekdayModel[number: $0]?.name }).joined(separator: ", ")
			return "🔔 "
				+ "notification".loc
				+ ": \(timeFormatter.string(from: time)) "
				+ "every".loc
				+ " "
				+ weekdaysString
		}

		return nil
	}
}
