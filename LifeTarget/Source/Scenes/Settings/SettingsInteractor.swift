//
//  SettingsInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import Foundation
import UIKit

protocol SettingsInteractionLogic {

	func start()
	func didSelectTheme(_ theme: Theme)
	func notificationDidTapped()

	func addTestTaskTapped()
	func showTutorialTapped()
	func writeToDevelopersTapped()
}

final class SettingsInteractor {

	typealias Scene = SettingsScene

	private let router: MainFlowLogic
	private let presenter: SettingsPresentationLogic
	private let themeService: ThemeServiceProtocol
	private let notificationPermission: Permission

	init(router: MainFlowLogic, presenter: SettingsPresentationLogic,
		 themeService: ThemeServiceProtocol, notificationPermission: Permission) {
		self.router = router
		self.presenter = presenter
		self.themeService = themeService
		self.notificationPermission = notificationPermission
	}

	private func updateAllData() {
		self.presenter.select(theme: self.themeService.theme)
		self.presenter.update(notification: self.notificationPermission.status)
		updateBuild()
	}

	private func setupListeners() {
		notificationPermission.onChange(for: self) { [weak self] status in
			self?.presenter.update(notification: status)
		}
	}

	private func updateBuild() {
		guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return
		}

		if version.hasPrefix("0.") {
			presenter.update(build: "\(version) Beta")
		} else {
			presenter.update(build: version)
		}
	}
}

// MARK: - SettingsInteractionLogic
extension SettingsInteractor: SettingsInteractionLogic {

	func start() {
		setupListeners()
		updateAllData()
	}

	func didSelectTheme(_ theme: Theme) {
		themeService.theme = theme
	}

	func notificationDidTapped() {
		switch notificationPermission.status {
			case .none:
				notificationPermission.requestAccess { [weak self] status in
					self?.presenter.update(notification: status)
					self?.notificationPermission.refresh()
				}
			case .restricted:
				let settings = UIApplication.openSettingsURLString
				guard let url = URL(string: settings),
					  UIApplication.shared.canOpenURL(url) else { return }
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			default: break
		}
	}

	func addTestTaskTapped() {

	}

	func showTutorialTapped() {

	}

	func writeToDevelopersTapped() {
		guard let url = URL(string: "mailto:\(DeveloperEmail)"),
			  UIApplication.shared.canOpenURL(url) else { return }
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
}
