//
//  NotificationPermissionView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import UIKit

protocol NotificationPermissionViewDelegate: AnyObject {
	func notificationButtonTapped()
}

final class NotificationPermissionView: BaseView {

	weak var delegate: NotificationPermissionViewDelegate?

	private let title: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.font = Fonts.caption
		view.textColor = Colors.secondaryLabel
		view.text = "notification_status".loc
		return view
	}()

	private let status: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.font = Fonts.text
		return view
	}()

	private let actionButton = ActionButton()

	func update(with model: SettingsScene.NotificationViewModel) {
		status.text = model.status
		status.textColor = model.statusColor

		actionButton.title = model.buttonText
		actionButton.isHidden = model.buttonIsHidden
	}

	override func setupUI() {
		layer.cornerRadius = Sizes.cornerRadius
		addSubviews(title, status, actionButton)

		actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor, constant: Margin.standart),
			title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,

			status.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Margin.small),
			status.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			status.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,
			status.bottomAnchor.constraint(equalTo: bottomAnchor,
											constant: Margin.standart).reversed,

			actionButton.trailingAnchor.constraint(equalTo: trailingAnchor,
												   constant: Margin.standart).reversed,
			actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

	@objc private func buttonTapped() {
		delegate?.notificationButtonTapped()
	}
}
