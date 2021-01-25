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

	private lazy var assemble = Assemble(window: window)

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		if window == nil {
			window = UIWindow()
		}

		assemble.start()

		return true
	}
}
