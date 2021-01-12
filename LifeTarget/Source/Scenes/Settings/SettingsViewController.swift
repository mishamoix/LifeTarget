//
//  SettingsViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {

	func show(viewModel: SettingsScene.ViewModel)
}

final class SettingsViewController: UIViewController {

	typealias Scene = SettingsScene

	private let interactor: SettingsInteractionLogic

	init(interactor: SettingsInteractionLogic) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		interactor.start()
	}

	private func setup() {
		setupConstraints()
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
		])
	}
}

// MARK: - SettingsDisplayLogic
extension SettingsViewController: SettingsDisplayLogic {

	func show(viewModel: SettingsScene.ViewModel) {}
}
