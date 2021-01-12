//
//  SettingsPresenter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

protocol SettingsPresentationLogic {}

final class SettingsPresenter {

	typealias Scene = SettingsScene

	weak var view: SettingsDisplayLogic?
}

extension SettingsPresenter: SettingsPresentationLogic {}
