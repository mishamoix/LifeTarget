//
//  NotificationPermission.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import Foundation
import UserNotifications
import UIKit

final class NotificationPermission {

	private struct Wrapper {
		weak var object: AnyObject?
		var completion: (Authorized) -> Void
	}

	private let center = UNUserNotificationCenter.current()
	private var cachedStatus: Authorized = .none
	private var listeners: [Wrapper] = []

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	init() {
		refreshStatus()
		addListener()
	}

	@objc private func refreshStatus() {
		center.getNotificationSettings { [weak self] settings in
			guard let self = self else { return }

			let previousStatus = self.cachedStatus

			switch settings.authorizationStatus {
				case .authorized, .ephemeral, .provisional:
					self.cachedStatus = .granted
				case .notDetermined:
					self.cachedStatus = .none
				case .denied:
					self.cachedStatus = .restricted
				@unknown default:
					self.cachedStatus = .restricted
			}

			if previousStatus != self.cachedStatus {
				self.notifyListeners()
			}
		}
	}

	private func addListener() {
		NotificationCenter.default.addObserver(self, selector: #selector(refreshStatus),
											   name: UIApplication.didBecomeActiveNotification, object: nil)
	}

	private func notifyListeners() {
		listeners = listeners.filter({ $0.object != nil })
		listeners.forEach({ $0.completion(cachedStatus) })
	}
}

extension NotificationPermission: Permission {
	var status: Authorized {
		return cachedStatus
	}

	func requestAccess(_ completion: @escaping (Authorized) -> Void) {
		center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] autorized, _ in
			guard let self = self else { return }

			if autorized {
				self.cachedStatus = .granted
			} else {
				self.cachedStatus = .restricted
			}

			completion(self.cachedStatus)

			self.refreshStatus()
			self.notifyListeners()
		}
	}

	func onChange(for object: AnyObject?, _ completion: @escaping (Authorized) -> Void) {
		listeners.append(Wrapper(object: object, completion: completion))
	}

	func refresh() {
		refreshStatus()
	}
}
