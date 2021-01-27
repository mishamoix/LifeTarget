//
//  TutorialView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 26.01.2021.
//

import UIKit

final class TutorialView: BaseView {
	private let image: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleAspectFit
		view.clipsToBounds = true
		return view
	}()

	private let text: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.font = Fonts.text
		view.textColor = Colors.label
		view.numberOfLines = 0
		view.textAlignment = .center
		return view
	}()

	override func setupUI() {
		translatesAutoresizingMaskIntoConstraints = true
		addSubviews(image, text)

		NSLayoutConstraint.activate([
			image.topAnchor.constraint(equalTo: topAnchor),
			image.leadingAnchor.constraint(equalTo: leadingAnchor),
			image.trailingAnchor.constraint(equalTo: trailingAnchor),

			text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Margin.standart),
			text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,
			text.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}

	func update(with model: Tutorial) {
		image.image = model.image
		text.text = model.text
	}
}
