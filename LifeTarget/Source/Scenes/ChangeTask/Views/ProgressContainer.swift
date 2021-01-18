//
//  ProgressContainer.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 15.01.2021.
//

import UIKit

final class ProgressContainer: UIView {

	private let title: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = Fonts.text
		label.textColor = Colors.label
		label.numberOfLines = 0
		label.text = "progress_title".loc
		return label
	}()

	private let exposition: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = Fonts.caption
		label.textColor = Colors.secondaryLabel
		label.numberOfLines = 0
		label.text = "progress_exposition".loc
		return label
	}()

	private let separator = Separator()

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

	var progress: ChangeTaskScene.Progress? {
		guard let text = inputField.value?.cleanWhitespace, let number = Float(text) else {
			return nil
		}

		return ChangeTaskScene.Progress(number: number)
	}

	convenience init() {
		self.init(frame: .zero)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	func update(with task: Task) {
		if let maxCount = task.progress?.maxCount {
			inputField.value = String(Int(maxCount))
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		backgroundColor = Colors.secondaryBackground
		layer.cornerRadius = Sizes.cornerRadius
		translatesAutoresizingMaskIntoConstraints = false

		addSubviews(title, exposition, separator, inputField)

		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor, constant: Margin.standart),
			title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: Margin.standart).reversed,

			inputField.centerYAnchor.constraint(equalTo: title.centerYAnchor),
			inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,
			inputField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

			separator.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: Margin.standart),
			separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			separator.trailingAnchor.constraint(equalTo: trailingAnchor),

			exposition.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: Margin.standart),
			exposition.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			exposition.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,
			exposition.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Margin.standart).reversed
		])
	}
}
