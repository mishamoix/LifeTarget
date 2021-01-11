//
//  TaskCell.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

final class TaskCell: UITableViewCell {

	private enum Consts {
		static let insets: UIEdgeInsets = UIEdgeInsets(top: Margin.standart,
													   left: Margin.standart,
													   bottom: 0,
													   right: Margin.standart)
	}

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

	private let container: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.secondaryBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = Sizes.cornerRadius
		return view
	}()

	private let taskProgressContainer: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.spacing = Margin.standart
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let taskProgress = TaskProgressView()

	override func prepareForReuse() {
		super.prepareForReuse()
		stub()
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupViews()
		stub()
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	private func setupViews() {
		selectionStyle = .none

		contentView.addSubview(container)
		container.addSubviews(title, exposition, taskProgressContainer)

		contentView.backgroundColor = .clear
		backgroundColor = .clear
		setupConstraints()

		taskProgressContainer.addArrangedSubview(taskProgress)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Consts.insets.top),
			container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
											   constant: Consts.insets.left),
			container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
												constant: Consts.insets.right).reversed,
			container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
											  constant: Consts.insets.bottom).reversed,

			title.topAnchor.constraint(equalTo: container.topAnchor, constant: Margin.standart),
			title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margin.standart),
			title.trailingAnchor.constraint(equalTo: container.trailingAnchor,
											constant: Margin.standart).reversed,

			exposition.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Margin.small),
			exposition.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margin.standart),
			exposition.trailingAnchor.constraint(equalTo: container.trailingAnchor,
												 constant: Margin.standart).reversed,

			taskProgressContainer.topAnchor.constraint(equalTo: exposition.bottomAnchor,
													   constant: Margin.large),
			taskProgressContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margin.standart),
			taskProgressContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor,
												 constant: Margin.standart).reversed,
			taskProgressContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor,
														  constant: Margin.standart).reversed
		])
	}

	private func stub() {
		title.text = "Это большой лейбл бла бла"

		//swiftlint:disable:next line_length
		exposition.text = "Тут много какого то описания Сайт b tot xnj-nj"

		taskProgress.stub()
		taskProgress.title.text = "21/150 дней"
	}
}
