//
//  CompleteButtonView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 18.01.2021.
//

import UIKit

final class CompleteButtonView: UIView {

	var tapped: (() -> Void)?

	private let button: UIButton = ActionButton(title: "complete_button".loc)

	convenience init() {
		self.init(frame: .zero)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(button)
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalTo: topAnchor),
			button.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Margin.large),
			button.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: Margin.large).reversed,
			button.bottomAnchor.constraint(equalTo: bottomAnchor),
			button.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}

	@objc private func buttonTapped() {
		tapped?()
	}
}
