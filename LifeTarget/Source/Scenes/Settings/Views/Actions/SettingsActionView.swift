//
//  SettingsActionView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import UIKit

protocol SettingsActionViewDelegate: AnyObject {
	func addTestTaskTapped()
	func showTutorialTapped()
	func writeToDevelopersTapped()
}

final class SettingsActionView: BaseView {

	weak var delegate: SettingsActionViewDelegate?

	private let stackView: UIStackView = {
		let view = UIStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.axis = .vertical
		view.backgroundColor = Colors.secondaryBackground
		return view
	}()

	private let testTask = SettingsAction(title: "test_task".loc)
	private let tutorial = SettingsAction(title: "tutorial".loc)
	private let writeToDevelopers = SettingsAction(title: "write_to_developers".loc)

	override func setupUI() {
		super.setupUI()

		layer.cornerRadius = Sizes.cornerRadius

		testTask.tapped = { [weak self] in
			self?.delegate?.addTestTaskTapped()
		}

		tutorial.tapped = { [weak self] in
			self?.delegate?.showTutorialTapped()
		}

		writeToDevelopers.tapped = { [weak self] in
			self?.delegate?.writeToDevelopersTapped()
		}

		stackView.addArrangedSubview(testTask)
		stackView.addArrangedSubview(Separator())
		stackView.addArrangedSubview(tutorial)
		stackView.addArrangedSubview(Separator())
		stackView.addArrangedSubview(writeToDevelopers)

		addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
												constant: Margin.standart).reversed,
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
