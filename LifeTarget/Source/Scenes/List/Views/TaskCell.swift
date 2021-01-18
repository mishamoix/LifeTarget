//
//  TaskCell.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
	func editTapped(cell: TaskCell)
}

final class TaskCell: UITableViewCell {

	private enum Consts {
		static let insets: UIEdgeInsets = UIEdgeInsets(top: Margin.standart,
													   left: Margin.standart,
													   bottom: 0,
													   right: Margin.standart)
	}

	weak var delegate: TaskCellDelegate?

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

	private let actionsContainer: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.distribution = .fillEqually
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let progressViewQueue = ViewQueue<TaskProgressView>(initializer: { TaskProgressView() })

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupViews()
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	func update(with task: TaskViewModel) {
		title.text = task.task.title
		exposition.text = task.task.exposition

		taskProgressContainer.arrangedSubviews.forEach({ $0.isHidden = true })

		task.progresses.enumerated().forEach({ (idx, progress) in
			let view = progressViewQueue.view(at: idx)
			if view.superview == nil {
				taskProgressContainer.addArrangedSubview(view)
			}
			view.isHidden = false
			view.update(with: progress)
		})
	}

	private func setupViews() {
		selectionStyle = .none

		contentView.addSubview(container)
		container.addSubviews(title, exposition, taskProgressContainer, actionsContainer)

		contentView.backgroundColor = .clear
		backgroundColor = .clear
		setupConstraints()

		setupActionsContainer()

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editTapped))
		container.isUserInteractionEnabled = true
		container.addGestureRecognizer(tapGesture)
	}

	private func setupActionsContainer() {
		let editButton = Button(title: nil, image: UIImage.named("pencilEdit"))
		editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
		actionsContainer.addArrangedSubview(editButton)
		actionsContainer.addArrangedSubview(Button(title: "subtasks_count".loc(count: 0),
												   image: UIImage.named("chevronRight")))

		let separator = Separator()
		separator.axis = .vertical
		separator.color = Colors.background
		actionsContainer.addSubview(separator)

		NSLayoutConstraint.activate([
			separator.topAnchor.constraint(equalTo: actionsContainer.topAnchor),
			separator.bottomAnchor.constraint(equalTo: actionsContainer.bottomAnchor),
			separator.centerXAnchor.constraint(equalTo: actionsContainer.centerXAnchor,
											   constant: Margin.small).reversed
		])
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

			actionsContainer.topAnchor.constraint(equalTo: taskProgressContainer.bottomAnchor,
													   constant: Margin.large),
			actionsContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Margin.standart),
			actionsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor,
												 constant: Margin.standart).reversed,
			actionsContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor,
														  constant: Margin.standart).reversed
		])
	}

	@objc private func editTapped() {
		delegate?.editTapped(cell: self)
	}
}
