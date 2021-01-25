//
//  NotificationService.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 20.01.2021.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
	func update(action: NotificationServiceAction)
}

enum NotificationServiceAction {

	case remove(id: String)
	case add(id: String, notification: PushNotification, title: String, message: String?)
}

final class NotificationService: NSObject {

	private enum Consts {
		static let maxCount: Int = 10
	}

	static let shared = NotificationService()

	static var permission: Permission = NotificationPermission()
	private let notificationService = UNUserNotificationCenter.current()

	private override init() {
		super.init()

		notificationService.delegate = self
	}

	private func add(id: String, notification: PushNotification, title: String, message: String?) {
		requestAccess { granted in
			if granted {
				self.register(id: id, notification: notification, title: title, message: message)
			}
		}
	}

	private func remove(by id: String) {
		let ids = (0..<Consts.maxCount).map({ makeId(id: id, number: $0) })
		notificationService.removePendingNotificationRequests(withIdentifiers: ids)
	}

	private func makeId(id: String, number: Int) -> String {
		"\(id)_\(number)"
	}

	private func requestAccess(result: @escaping (Bool) -> Void) {
		Self.permission.requestAccess { authorized in
			result(authorized != .restricted)
		}
	}

	private func register(id: String, notification: PushNotification, title: String, message: String?) {
		let content = UNMutableNotificationContent()
		content.title = title
		content.sound = .default
		if let message = message {
			content.body = message
		}

		if let triggers = notification.triggers?.prefix(Consts.maxCount) {
			for (idx, trigger) in triggers.enumerated() {
				let resultId = makeId(id: id, number: idx)
				let request = UNNotificationRequest(identifier: resultId, content: content,
													trigger: trigger)
				notificationService.add(request, withCompletionHandler: nil)
			}
		}
	}
}

extension NotificationService: NotificationServiceProtocol {
	func update(action: NotificationServiceAction) {
		switch action {
			case .add(let id, let notification, let title, let message):
				remove(by: id)
				add(id: id, notification: notification,
					title: title, message: message)
			case .remove(let id):
				remove(by: id)
		}
	}
}

extension NotificationService: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .badge, .sound])
	}
}

private extension PushNotification {

	var triggers: [UNNotificationTrigger]? {
		let current = Date()
		if let date = date, date > current {
			let interval = date.timeIntervalSince1970 - current.timeIntervalSince1970
			return [UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)]
		} else if let weekdays = weekdays, let timestamp = dayTime {
			let time = Date(timeIntervalSince1970: timestamp)
			let calendar = Calendar.current
			let hour = calendar.component(.hour, from: time)
			let minute = calendar.component(.minute, from: time)

			let result = weekdays
				.map({ DateComponents(hour: hour, minute: minute, weekday: $0) })
				.map({ UNCalendarNotificationTrigger(dateMatching: $0, repeats: true) })

			return result
		}

		return nil
	}
}
