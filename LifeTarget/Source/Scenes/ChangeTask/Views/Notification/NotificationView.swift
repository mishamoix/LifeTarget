//
//  NotificationView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

enum NotificationType {
	case exactTime
	case pereodically
}

protocol NotificationSubviewDelegate: AnyObject {
	func didSelectTime(with type: NotificationType)
}

final class NotificationView: BaseView {

	var notification: ChangeTaskScene.Notify {
		return ChangeTaskScene.Notify(exactDate: exactDateTimeView.currentDate,
									  weekdays: pereodicalTime.weekdays.selected,
									  time: pereodicalTime.currentTime)
	}

	private let container: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.spacing = Margin.standart
		view.backgroundColor = Colors.secondaryBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let title: UILabel = {
		let view = UILabel()
		view.font = Fonts.text
		view.textColor = Colors.label
		view.text = "notification_title".loc
		view.translatesAutoresizingMaskIntoConstraints = false
		view.numberOfLines = 0
		return view
	}()

	private let exposition: UILabel = {
		let view = UILabel()
		view.font = Fonts.caption
		view.textColor = Colors.secondaryLabel
		view.text = "notification_exposition".loc
		view.translatesAutoresizingMaskIntoConstraints = false
		view.numberOfLines = 0
		return view
	}()

	private lazy var exactDateTimeView = NotificationDateTimeView(baseView: baseView,
																  delegate: self)
	private let separator = NotificationDelimeterView()
	private lazy var pereodicalTime = NotificationPereodicalTime(baseView: baseView,
																 delegate: self)

	private let baseView: UIView

	init(baseView: UIView) {
		self.baseView = baseView
		super.init()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func update(with task: Task) {
		guard let notification = task.notification else { return }
		exactDateTimeView.update(with: notification)
		pereodicalTime.update(with: notification)
	}

	override func setupUI() {
		addSubview(container)

		clipsToBounds = true
		layer.cornerRadius = Sizes.cornerRadius

		container.addArrangedSubview(title)
		container.addArrangedSubview(exactDateTimeView)
		container.addArrangedSubview(separator)
		container.addArrangedSubview(pereodicalTime)
		container.addArrangedSubview(exposition)

		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: topAnchor, constant: Margin.standart),
			container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			container.trailingAnchor.constraint(equalTo: trailingAnchor,
												constant: Margin.standart).reversed,
			container.bottomAnchor.constraint(equalTo: bottomAnchor,
											  constant: Margin.standart).reversed
		])
	}
}

extension NotificationView: NotificationSubviewDelegate {
	func didSelectTime(with type: NotificationType) {
		switch type {
			case .exactTime:
				pereodicalTime.nullify()
			case .pereodically:
				exactDateTimeView.nullify()
		}
	}
}
