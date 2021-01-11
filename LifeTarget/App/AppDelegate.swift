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

	private let mainFlow = MainFlow()

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		if window == nil {
			window = UIWindow()
		}

		window?.rootViewController = mainFlow.mainViewController
		window?.makeKeyAndVisible()

		mainFlow.startFlow()
		return true
	}
}
