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
		let view = Button(title: "complete_button".loc, image: nil)
		view.contentEdgeInsets = UIEdgeInsets(horizontal: Margin.large)
		view.minimumHeight = Consts.size
		view.setTitleColor(Colors.label, for: .normal)
		view.backgroundColor = Colors.lightBackground
		view.layer.cornerRadius = Sizes.cornerRadius
		view.addShadow()
		return view
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
