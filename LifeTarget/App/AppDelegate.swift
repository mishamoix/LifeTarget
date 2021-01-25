//
//  AppDelegate.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 01.11.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	private lazy var mainFlow = MainFlow(themeService: themeService)
	private lazy var themeService = ThemeService(window: window)

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		if window == nil {
			window = UIWindow()
		}

		window?.rootViewController = mainFlow.mainViewController
		window?.makeKeyAndVisible()
		window?.layer.cornerRadius = 2.0
		window?.clipsToBounds = true

		mainFlow.startFlow()
		return true
	}
}
