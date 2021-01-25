//
//  SettingsViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {

	func select(theme: Theme)
}

final class SettingsViewController: UIViewController {

	typealias Scene = SettingsScene

	private let interactor: SettingsInteractionLogic

	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Colors.background
		view.contentInset = UIEdgeInsets(vertical: Margin.standart)
		view.alwaysBounceVertical = true
		return view
	}()

	private let container: UIStackView = {
		let view = UIStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Colors.background
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.spacing = Margin.standart
		return view
	}()

	private let appAppearanceView = AppAppearanceView()

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
		view.backgroundColor = Colors.background
		view.addSubview(scrollView)
		navigationItem.title = "settings".loc
		scrollView.addSubview(container)

		appAppearanceView.delegate = self

		if #available(iOS 13.0, *) {
			container.addArrangedSubview(appAppearanceView)
		}

		setupConstraints()
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			container.topAnchor.constraint(equalTo: scrollView.topAnchor),
			container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Margin.standart),
			container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: Margin.standart).reversed,
			container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			container.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Margin.standart)
		])
	}

}

// MARK: - SettingsDisplayLogic
extension SettingsViewController: SettingsDisplayLogic {

	func select(theme: Theme) {
		appAppearanceView.select(theme: theme)
	}

}

extension SettingsViewController: AppAppearanceViewDelegate {
	func didSelectTheme(_ theme: Theme) {
		interactor.didSelectTheme(theme)
	}
}
