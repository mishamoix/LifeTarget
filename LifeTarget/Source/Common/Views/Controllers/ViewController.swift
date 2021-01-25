//
//  ViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import UIKit
import MBProgressHUD

protocol ViewControllerLoadable {
	func updateLoader(hidden: Bool)
}

class ViewController: UIViewController, ViewControllerLoadable {

	private let loaderDebouncer = Debouncer(seconds: 0.15)

	override var prefersStatusBarHidden: Bool {
		false
	}

	func updateLoader(hidden: Bool) {
		if hidden {
			loaderDebouncer.cancel()
			MBProgressHUD.hide(for: view, animated: true)
		} else {
			loaderDebouncer.execute { [weak self] in
				guard let self = self else { return }
				MBProgressHUD.showAdded(to: self.view, animated: true)
			}
		}
	}
}
