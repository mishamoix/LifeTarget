//
//  SettingsAction.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import UIKit

final class SettingsAction: BaseView {

	var tapped: (() -> Void)?

	private let title: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.font = Fonts.text
		view.textColor = Colors.label
		return view
	}()

	private let image: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.image = UIImage.named("chevronRight")
		view.tintColor = Colors.secondaryLabel
		return view
	}()

	init(title: String) {
		super.init(frame: .zero)
		self.title.text = title
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setupUI() {
		super.setupUI()
		addSubviews(title, image)

		let tap = UITapGestureRecognizer(target: self, action: #selector(tappedAtView))
		addGestureRecognizer(tap)
		isUserInteractionEnabled = true

		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor, constant: Margin.standart),
			title.leadingAnchor.constraint(equalTo: leadingAnchor),
			title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Margin.standart).reversed,

			image.centerYAnchor.constraint(equalTo: title.centerYAnchor),
			image.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: Margin.standart),
			image.trailingAnchor.constraint(equalTo: trailingAnchor),
			image.widthAnchor.constraint(equalToConstant: 16),
			image.heightAnchor.constraint(equalToConstant: 16)
		])
	}

	@objc private func tappedAtView() {
		tapped?()
	}
}
