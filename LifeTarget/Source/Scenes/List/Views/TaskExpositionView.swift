//
//  TaskExpositionView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 18.01.2021.
//

import UIKit

final class TaskExpositionView: UIView {

	private let title: UILabel = {
		let label = UILabel()
		label.textColor = Colors.label
		label.font = Fonts.title
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		return label
	}()

	private let exposition: UILabel = {
		let label = UILabel()
		label.textColor = Colors.secondaryLabel
		label.font = Fonts.text
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 3
		return label
	}()

	convenience init() {
		self.init(frame: .zero)
	}

	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func update(with task: TaskViewModel) {
		title.text = task.task.title
		exposition.text = task.task.exposition
	}

	private func setupUI() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = Colors.secondaryBackground
		addSubviews(title, exposition)

		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor),
			title.leadingAnchor.constraint(equalTo: leadingAnchor),
			title.trailingAnchor.constraint(equalTo: trailingAnchor),

			exposition.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Margin.small),
			exposition.leadingAnchor.constraint(equalTo: leadingAnchor),
			exposition.trailingAnchor.constraint(equalTo: trailingAnchor),
			exposition.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
