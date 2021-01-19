//
//  NotificationDelimeterView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

final class NotificationDelimeterView: BaseView {

	private let separator: UIView = {
		let view = Separator()
		return view
	}()

	private let text: UILabel = {
		let view = UILabel()
		view.textColor = Colors.secondaryLabel
		view.font = Fonts.caption
		view.text = " or ".loc
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Colors.secondaryBackground
		return view
	}()

	override func setupUI() {
		addSubviews(separator, text)

		NSLayoutConstraint.activate([
			text.topAnchor.constraint(equalTo: topAnchor),
			text.centerXAnchor.constraint(equalTo: centerXAnchor),
			text.bottomAnchor.constraint(equalTo: bottomAnchor),

			separator.leadingAnchor.constraint(equalTo: leadingAnchor),
			separator.trailingAnchor.constraint(equalTo: trailingAnchor),
			separator.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}
