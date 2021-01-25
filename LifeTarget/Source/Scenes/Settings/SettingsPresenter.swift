//
//  SettingsPresenter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

protocol SettingsPresentationLogic {
	func select(theme: Theme)
}

final class SettingsPresenter {

	typealias Scene = SettingsScene

	weak var view: SettingsDisplayLogic?
}

extension SettingsPresenter: SettingsPresentationLogic {
	func select(theme: Theme) {
		view?.select(theme: theme)
	}
}
