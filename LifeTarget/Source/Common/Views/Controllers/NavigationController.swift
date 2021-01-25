//
//  NavigationController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import UIKit

final class NavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationBar.tintColor = Colors.accent
		navigationBar.shadowImage = UIColor.clear.as1ptImage()

		navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: Colors.accent
		]
	}
}
