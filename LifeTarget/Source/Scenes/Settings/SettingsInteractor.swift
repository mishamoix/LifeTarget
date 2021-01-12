//
//  SettingsInteractor.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

protocol SettingsInteractionLogic {

	func start()
}

final class SettingsInteractor {

	typealias Scene = SettingsScene

	private let router: MainFlowLogic
	private let presenter: SettingsPresentationLogic

	init(router: MainFlowLogic,
		 presenter: SettingsPresentationLogic) {
		self.router = router
		self.presenter = presenter
	}
}

// MARK: - SettingsInteractionLogic
extension SettingsInteractor: SettingsInteractionLogic {

	func start() {}
}
