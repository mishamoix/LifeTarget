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

	func addTestTaskTapped(viewController: ViewController)
	func showTutorialTapped()
	func writeToDevelopersTapped()
}

final class SettingsInteractor {

	typealias Scene = SettingsScene

	private let router: MainFlowLogic
	private let presenter: SettingsPresentationLogic
	private let themeService: ThemeServiceProtocol
	private let notificationPermission: Permission
	private let taskProvider: ExampleTaskProviderProtocol

	init(router: MainFlowLogic, presenter: SettingsPresentationLogic,
		 themeService: ThemeServiceProtocol, notificationPermission: Permission,
		 taskProvider: ExampleTaskProviderProtocol) {
		self.router = router
		self.presenter = presenter
		self.themeService = themeService
		self.notificationPermission = notificationPermission
		self.taskProvider = taskProvider
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

	private func showExampleTaskAdded(on viewController: ViewController) {
		let alert = UIAlertController(title: "example_task_added".loc,
									  message: "example_task_added_message".loc, preferredStyle: .alert)
		viewController.present(alert, animated: true)

		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			alert.dismiss(animated: true, completion: nil)
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

	func addTestTaskTapped(viewController: ViewController) {
		viewController.updateLoader(hidden: false)
		taskProvider.generateAndSave { [weak self, weak viewController] in
			guard let viewController = viewController else { return }
			DispatchQueue.mainAsyncIfNeeded {
				viewController.updateLoader(hidden: true)
				self?.showExampleTaskAdded(on: viewController)
				self?.router.refreshTaskList()
			}
		}
	}

	func showTutorialTapped() { }

	func writeToDevelopersTapped() {
		guard let url = URL(string: "mailto:\(DeveloperEmail)"),
			  UIApplication.shared.canOpenURL(url) else { return }
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
}
