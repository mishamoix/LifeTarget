//
//  DurationButton.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

final class DurationButton: UIView {

	var caption: String? = nil {
		didSet {
			captionLabel.text = caption
		}
	}

	var buttonLabel: String? = nil {
		didSet {
			button.setTitle(buttonLabel, for: .normal)
		}
	}

	var didTapped: (() -> Void)?

	private let captionLabel: UILabel = {
		let label = UILabel()
		label.font = Fonts.caption
		label.textColor = Colors.secondaryLabel
		label.translatesAutoresizingMaskIntoConstraints = false
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		return label
	}()

	private let button: Button = {
		let view = Button(title: nil, image: nil)
		view.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
		view.contentHorizontalAlignment = .trailing
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

		button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)

		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = Colors.secondaryBackground

		addSubviews(captionLabel, button)

		NSLayoutConstraint.activate([
			captionLabel.topAnchor.constraint(equalTo: topAnchor),
			captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.small - 2),

			button.topAnchor.constraint(equalTo: captionLabel.bottomAnchor),
			button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			button.trailingAnchor.constraint(equalTo: trailingAnchor),
			button.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}

	@objc private func buttonDidTapped() {
		didTapped?()
	}
}
