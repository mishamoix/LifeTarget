//
//  SettingsInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

protocol SettingsInteractionLogic {

	func start()
	func didSelectTheme(_ theme: Theme)
}

final class SettingsInteractor {

	typealias Scene = SettingsScene

	private let router: MainFlowLogic
	private let presenter: SettingsPresentationLogic
	private let themeService: ThemeServiceProtocol

	init(router: MainFlowLogic,
		 presenter: SettingsPresentationLogic,
		 themeService: ThemeServiceProtocol) {
		self.router = router
		self.presenter = presenter
		self.themeService = themeService
	}
}

// MARK: - SettingsInteractionLogic
extension SettingsInteractor: SettingsInteractionLogic {

	func start() {
		presenter.select(theme: themeService.theme)
	}

	func didSelectTheme(_ theme: Theme) {
		themeService.theme = theme
	}
}
