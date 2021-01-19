//
//  ProgressContainer.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 15.01.2021.
//

import UIKit

final class ProgressContainer: UIView {

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

	private let filedsContainer: UIStackView = {
		let view = UIStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.spacing = Margin.standart
		return view
	}()

	private let currentField = ProgressField(title: "current_activities".loc, placeholder: "10")
	private let maxCountField = ProgressField(title: "max_count_activities_title".loc, placeholder: "400")

	var progress: ChangeTaskScene.Progress? {
		guard let maxProgress = maxCountField.value else {
			return nil
		}

		return ChangeTaskScene.Progress(maxCount: Float(maxProgress),
										currentCount: currentField.value?.float)
	}

	convenience init() {
		self.init(frame: .zero)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	func update(with task: Task) {
		currentField.isHidden = false
		currentField.value = task.progress?.current.int
		maxCountField.value = task.progress?.maxCount.int
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		backgroundColor = Colors.secondaryBackground
		layer.cornerRadius = Sizes.cornerRadius
		translatesAutoresizingMaskIntoConstraints = false

		addSubviews(filedsContainer, exposition, separator)

		filedsContainer.addArrangedSubview(currentField)
		filedsContainer.addArrangedSubview(maxCountField)

		currentField.isHidden = true

		setupConstraints()
		addShadow()
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			filedsContainer.topAnchor.constraint(equalTo: topAnchor, constant: Margin.standart),
			filedsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			filedsContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,

			separator.topAnchor.constraint(equalTo: filedsContainer.bottomAnchor, constant: Margin.standart),
			separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			separator.trailingAnchor.constraint(equalTo: trailingAnchor),

			exposition.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: Margin.standart),
			exposition.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			exposition.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,
			exposition.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Margin.standart).reversed
		])
	}
}
