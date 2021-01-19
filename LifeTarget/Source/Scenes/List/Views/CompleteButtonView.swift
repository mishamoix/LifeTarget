//
//  CompleteButtonView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 18.01.2021.
//

import UIKit

final class CompleteButtonView: UIView {

	private enum Consts {
		static let size: CGFloat = 36
	}

	var tapped: (() -> Void)?

	private let button: UIButton = {
		let button = Button(title: "complete_button".loc, image: nil)
//		button.backgroundColor = Colors.progress
		button.minimumHeight = Consts.size
		button.layer.borderWidth = 2
		button.layer.borderColor = Colors.accent.cgColor
		button.layer.cornerRadius = Consts.size / 2.0
//		button.setTitleColor(Colors.secondaryBackground, for: .normal)
		button.contentEdgeInsets = UIEdgeInsets(top: 0, left: Margin.large,
												bottom: 0, right: Margin.large)
		return button
	}()

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
