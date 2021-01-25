//
//  ThemeService.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import UIKit

protocol ThemeServiceProtocol: AnyObject {
	var theme: Theme { get set }
}

final class ThemeService {

	@StorageRaw(key: "app_theme", defaultValue: .system)
	private var themeStorage: Theme

	private let window: UIWindow?

	init(window: UIWindow?) {
		self.window = window

		initialSetup()
	}

	private func initialSetup() {
		updateTheme()
	}

	func updateTheme() {
		if #available(iOS 13.0, *) {
			switch themeStorage {
				case .dark:
					window?.overrideUserInterfaceStyle = .dark
				case .light:
					window?.overrideUserInterfaceStyle = .light
				case .system:
					window?.overrideUserInterfaceStyle = .unspecified
			}
		}
	}

}

extension ThemeService: ThemeServiceProtocol {
	var theme: Theme {
		//swiftlint:disable:next implicit_getter
		get {
			themeStorage
		}

		set {
			themeStorage = newValue
			updateTheme()
		}
	}
}
