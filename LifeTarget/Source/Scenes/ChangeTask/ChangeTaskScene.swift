//
//  ChangeTaskScene.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import Foundation

enum ChangeTaskScene {

	enum Input {
		case adding(parent: Task?)
		case change(task: Task)
	}

	struct Model {
		let duration: Duration?
		let progress: Progress?
		let exposition: Exposition?
		let isCompleted: Bool
		let notification: Notify?

		var task: Task {
			let task = Task(title: exposition?.title.cleanWhitespace ?? "", exposition: exposition?.subtitle,
						progress: progress?.progress, duration: duration?.duration,
						notification: notification?.notification, isCompleted: isCompleted,
						createDate: Date(), updateDate: Date(), subtasks: nil, parent: nil)

			return task
		}
	}

	struct SetupViewModel {
		let title: String
		let saveButtonString: String
		let cancelButtonString: String

		let task: Task?

		let isModify: Bool
	}

	struct ErrorModel {
		let title: String
		let message: String
	}

	struct Duration {
		let start: Date?
		let finish: Date?

		var duration: Task.Duration? {
			guard let start = start, let end = finish else {
				return nil
			}

			return Task.Duration(start: start, end: end)
		}

		func validate() -> String? {
			if start == nil && finish == nil {
				return nil
			}

			guard let start = start else {
				return "duration_start_nil".loc
			}

			guard let finish = finish else {
				return "duration_finish_nil".loc
			}

			if start > finish {
				return "duration_start_greater_finish".loc
			}

			return nil
		}
	}

	struct Progress {
		let maxCount: Int
		let currentCount: Int?

		var progress: Task.Progress {
			return Task.Progress(maxCount: maxCount, current: currentCount ?? 0)
		}

		func validate() -> String? {
			if maxCount > Int.max - 1 {
				return "too_much_progress".loc
			}

			if let currentCount = currentCount, currentCount > maxCount {
				return "current_progress_greater_max".loc
			}

			return nil
		}
	}

	struct Exposition {
		let title: String
		let subtitle: String?

		func validate() -> String? {
			if title.cleanWhitespace.isEmpty {
				return "empty_title".loc
			}

			return nil
		}
	}

	struct Notify {
		let exactDate: Date?

		let weekdays: [Int]?
		let time: Date?

		var notification: PushNotification? {
			if let weekdays = weekdays, let time = time?.timeIntervalSince1970 {
				return PushNotification(weekdays: weekdays, dayTime: time, date: nil)
			} else if let date = exactDate {
				return PushNotification(weekdays: nil, dayTime: nil, date: date)
			}
			return nil
		}
	}
}
