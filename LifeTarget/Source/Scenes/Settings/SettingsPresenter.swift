//
//  SettingsPresenter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import Foundation

protocol SettingsPresentationLogic {
	func select(theme: Theme)
	func update(notification: Authorized)
	func update(build: String)
}

final class SettingsPresenter {

	typealias Scene = SettingsScene

	weak var view: SettingsDisplayLogic?
}

extension SettingsPresenter: SettingsPresentationLogic {
	func select(theme: Theme) {
		DispatchQueue.mainAsyncIfNeeded {
			self.view?.update(theme: theme)
		}
	}

	func update(notification: Authorized) {
		let model: Scene.NotificationViewModel
		switch notification {
		case .none:
			model = Scene.NotificationViewModel(status: "notification_status_none".loc,
												statusColor: Colors.secondaryLabel,
												buttonText: "notification_enable".loc)
		case .granted:
			model = Scene.NotificationViewModel(status: "notification_status_on".loc,
												statusColor: Colors.progress,
												buttonText: nil)

		case .restricted:
			model = Scene.NotificationViewModel(status: "notification_status_off".loc,
												statusColor: Colors.attention,
												buttonText: "go_to_settings".loc)

		}

		DispatchQueue.mainAsyncIfNeeded {
			self.view?.update(notification: model)
		}
	}

	func update(build: String) {
		let result = "build_version".loc + ": \(build)"
		DispatchQueue.mainAsyncIfNeeded {
			self.view?.update(build: result)
		}
	}
}
