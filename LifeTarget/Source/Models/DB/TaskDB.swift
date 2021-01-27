//
//  TaskDB.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 13.01.2021.
//

import Foundation
import CoreData

@objc(TaskDB)
public final class TaskDB: NSManagedObject {
	@NSManaged public var id: String
	@NSManaged public var title: String
	@NSManaged public var exposition: String?
	@NSManaged public var progressMaxCount: NSNumber?
	@NSManaged public var progressCurrent: NSNumber?
	@NSManaged public var durationStart: NSDate?
	@NSManaged public var durationEnd: NSDate?
	@NSManaged public var notificationWeekdays: [Int]?
	@NSManaged public var notificationDayTime: NSNumber?
	@NSManaged public var notificationDate: NSDate?
	@NSManaged public var parent: TaskDB?
	@NSManaged public var childs: NSSet?

	@NSManaged public var isCompleted: Bool

	@NSManaged public var createDate: NSDate
	@NSManaged public var updateDate: NSDate
}

extension TaskDB: DatabaseModelProtocol {
	typealias Input = Task

	func update(with model: Task) {
		if isInserted {
			id = model.id
			createDate = Date().nsDate
		}

		updateDate = Date().nsDate

		title = model.title
		exposition = model.exposition

		progressMaxCount = model.progress?.maxCount.nsNumber
		progressCurrent = model.progress?.current.nsNumber

		durationStart = model.duration?.start.nsDate
		durationEnd = model.duration?.end.nsDate

		notificationWeekdays = model.notification?.weekdays
		notificationDayTime = model.notification?.dayTime?.nsNumber
		notificationDate = model.notification?.date?.nsDate

		isCompleted = model.isCompleted
	}
}

extension Task {

	enum Level {
		case none
		case one
		case unlimited
		case custom(level: Int)

		var increase: Level {
			switch self {
				case .none, .one:
					return .none
				case .unlimited:
					return .unlimited
				case .custom(let level):
					let newValue = level - 1
					return newValue == 1 ? .one : .custom(level: newValue)
			}
		}

		var canGetChild: Bool {
			switch self {
				case .one, .custom, .unlimited:
					return true
				case .none:
					return false
			}
		}

		var canGetParent: Bool {
			switch self {
				case .one:
					return true
				default:
					return false
			}
		}

	}

	init(db model: TaskDB, level: Level = .one) {
		var progress: Task.Progress?
		var duration: Task.Duration?
		var childs: [Task]?
		var parent: Task?

		if let progressMax = model.progressMaxCount, let progressCurrent = model.progressCurrent {
			progress = Task.Progress(maxCount: progressMax.intValue,
									 current: progressCurrent.intValue)
		}

		if let start = model.durationStart, let end = model.durationEnd {
			duration = Task.Duration(start: start.date, end: end.date)
		}

		if level.canGetChild, let childsDB = model.childs?.allObjects as? [TaskDB] {
			childs = childsDB
				.map({ Task(db: $0, level: level.increase) })
				.sortedTask()
		}

		if level.canGetParent,
		   let parentDB = model.parent {
			parent = Task(db: parentDB, level: level.increase)
		}

		let notification = PushNotification(weekdays: model.notificationWeekdays?.sorted(),
										dayTime: model.notificationDayTime?.doubleValue,
										date: model.notificationDate?.date)

		self.init(id: model.id, title: model.title, exposition: model.exposition,
				  progress: progress, duration: duration, notification: notification,
				  isCompleted: model.isCompleted, createDate: model.createDate.date,
				  updateDate: model.updateDate.date, subtasks: childs, parent: Wrapper(parent))
	}
}
