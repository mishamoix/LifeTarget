//
//  ProgressField.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 18.01.2021.
//

import UIKit

final class ProgressField: UIView {

	var value: Int? {
		get {
			if let value = inputField.value?.cleanWhitespace, let result = Int(value) {
				return result
			}

			return nil
		}

		set {
			if let value = newValue {
				inputField.value = String(value)
			} else {
				inputField.value = nil
			}
		}
	}

	private let inputField: ValueTextField = {
		let view = ValueTextField(type: .int)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.autocorrectionType = .no
		view.keyboardType = .numberPad
		view.backgroundColor = Colors.background
		view.clipsToBounds = true
		view.layer.cornerRadius = 5
		view.placeholder = "progress_placeholder".loc
		view.textAlignment = .center
		view.font = Fonts.title
		view.tintColor = Colors.accent
		return view
	}()

	private let title: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = Fonts.text
		label.textColor = Colors.label
		label.numberOfLines = 0
		return label
	}()

	init(title: String, placeholder: String? = nil) {
		self.title.text = title
		inputField.placeholder = placeholder
		super.init(frame: .zero)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = Colors.secondaryBackground
		addSubviews(title, inputField)

		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor),
			title.leadingAnchor.constraint(equalTo: leadingAnchor),
			title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: Margin.standart).reversed,

			inputField.centerYAnchor.constraint(equalTo: title.centerYAnchor),
			inputField.trailingAnchor.constraint(equalTo: trailingAnchor),
			inputField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
			inputField.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
