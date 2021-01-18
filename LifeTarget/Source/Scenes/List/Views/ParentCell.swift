//
//  ParentCell.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 18.01.2021.
//

import UIKit

final class ParentCell: UITableViewCell {

	private let container: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.secondaryBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = Sizes.cornerRadius
		return view
	}()

	private let title: UILabel = {
		let label = UILabel()
		label.textColor = Colors.label
		label.font = Fonts.title
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func update(with task: TaskViewModel) {
		title.text = task.task.title
	}

	private func setupUI() {
		backgroundColor = .clear
		contentView.backgroundColor = .clear

		contentView.addSubview(container)
		container.addSubview(title)
		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: contentView.topAnchor,
										   constant: Margin.standart),
			container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
											   constant: Margin.standart),
			container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
												constant: Margin.standart).reversed,
			container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

			title.topAnchor.constraint(equalTo: container.topAnchor, constant: Margin.standart),
			title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margin.standart),
			title.trailingAnchor.constraint(equalTo: container.trailingAnchor,
											constant: Margin.standart).reversed,
			title.bottomAnchor.constraint(equalTo: container.bottomAnchor,
										  constant: Margin.standart).reversed
		])
	}
}
