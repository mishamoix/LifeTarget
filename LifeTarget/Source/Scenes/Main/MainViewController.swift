//
//  MainViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 01.11.2020.
//

import UIKit

final class MainViewController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}

	func add(viewController: UIViewController) {
		viewControllers = (viewControllers ?? []) + [viewController]
	}

	private func setup() {
		self.delegate = self
		tabBar.tintColor = Colors.accent
	}
}

extension MainViewController: UITabBarControllerDelegate { }
