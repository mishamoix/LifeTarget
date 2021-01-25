//
//  Assemble.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import UIKit

final class Assemble {

	private let window: UIWindow?

	private let notificationPermission = NotificationPermission()

	private lazy var mainFlow = MainFlow(themeService: themeService,
										 notificationPermission: notificationPermission)
	private lazy var themeService = ThemeService(window: window)

	init(window: UIWindow?) {
		self.window = window
	}

	func start() {
		setup()
		mainFlow.startFlow()
	}

	private func setup() {
		setupWindow()

		NotificationService.permission = notificationPermission
	}

	private func setupWindow() {
		window?.rootViewController = mainFlow.mainViewController
		window?.makeKeyAndVisible()
		window?.layer.cornerRadius = 2.0
		window?.clipsToBounds = true
	}
}
