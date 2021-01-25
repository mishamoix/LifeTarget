//
//  MainViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 01.11.2020.
//

import UIKit

final class MainViewController: UITabBarController {

	override var prefersStatusBarHidden: Bool {
		false
	}

	override func viewDidLoad() {
		UINavigationBar.appearance().shadowImage = UIColor.red.as1ptImage()
		super.viewDidLoad()
		setup()
	}

	func add(viewController: UIViewController) {
		viewControllers = (viewControllers ?? []) + [viewController]
	}

	private func setup() {
		self.delegate = self
		tabBar.tintColor = Colors.accent
		tabBar.clipsToBounds = true
	}
}

extension MainViewController: UITabBarControllerDelegate { }
