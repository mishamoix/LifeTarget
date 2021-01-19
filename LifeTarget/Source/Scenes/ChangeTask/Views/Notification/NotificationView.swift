//
//  NotificationView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

final class NotificationView: BaseView {

	private let container: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.spacing = Margin.standart
		view.backgroundColor = Colors.secondaryBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private lazy var exactDateTimeView = NotificationDateTimeView(baseView: baseView)
	private let separator = NotificationDelimeterView()
	private lazy var pereodicalTime = NotificationPereodicalTime(baseView: baseView)

	private let baseView: UIView

	init(baseView: UIView) {
		self.baseView = baseView
		super.init()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setupUI() {
		addSubview(container)

		clipsToBounds = true
		layer.cornerRadius = Sizes.cornerRadius

		container.addArrangedSubview(exactDateTimeView)
		container.addArrangedSubview(separator)
		container.addArrangedSubview(pereodicalTime)

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
