//
//  TaskCell.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
	func editTapped(cell: TaskCell)
	func subtasksOpenTapped(cell: TaskCell)
	func plusTapped(cell: TaskCell)
	func completeTapped(cell: TaskCell)
}

final class TaskCell: UITableViewCell {

	private enum Consts {
		static let insets: UIEdgeInsets = UIEdgeInsets(top: Margin.standart,
													   left: Margin.standart,
													   bottom: 0,
													   right: Margin.standart)
	}

	weak var delegate: TaskCellDelegate?

	private let taskExpositionView = TaskExpositionView()

	private let subtasksLabel: UILabel = {
		let label = UILabel()
		label.textColor = Colors.secondaryLabel
		label.font = Fonts.text
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		return label
	}()

	private let container: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.secondaryBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = Sizes.cornerRadius
		return view
	}()

	private let stackContainer: UIStackView = {
		let view = UIStackView()
		view.backgroundColor = Colors.secondaryBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.spacing = Margin.standart

		return view
	}()

	private let completeButton = CompleteButtonView()

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

	private let notificationLabel: UILabel = {
		let label = UILabel()
		label.textColor = Colors.secondaryLabel
		label.font = Fonts.caption
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		return label
	}()

	private let subtasksButton = Button(title: nil,
										image: UIImage.named("chevronRight"))

	private let progressViewQueue = ViewQueue<TaskProgressView>(initializer: { TaskProgressView() })

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

		if let result = progressViewQueue.view(at: 0).testPointInside(point, view: self) {
			return result
		}
		return super.hitTest(point, with: event)
	}

	func update(with task: TaskViewModel) {
		taskExpositionView.update(with: task)

		subtasksLabel.text = task.subtasks
		subtasksLabel.isHidden = task.subtasks == nil

		completeButton.isHidden = task.task.isCompleted

		notificationLabel.isHidden = task.notificationString == nil
		notificationLabel.text = task.notificationString

		subtasksButton.setTitle("subtasks_count".loc(count: task.task.subtasks?.count ?? 0),
								for: .normal)

		taskProgressContainer.arrangedSubviews.forEach({ $0.isHidden = true })
		taskProgressContainer.isHidden = task.progresses.isEmpty

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
		container.addSubview(stackContainer)

		stackContainer.addArrangedSubview(taskExpositionView)
		stackContainer.addArrangedSubview(subtasksLabel)
		stackContainer.addArrangedSubview(taskProgressContainer)
		stackContainer.addArrangedSubview(notificationLabel)
		stackContainer.addArrangedSubview(completeButton)
		stackContainer.addArrangedSubview(Separator())
		stackContainer.addArrangedSubview(actionsContainer)

		contentView.backgroundColor = .clear
		backgroundColor = .clear

		setupConstraints()
		setupActionsContainer()
		addPlusCounterHandler()

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(subtasksTapped))
		stackContainer.isUserInteractionEnabled = true
		stackContainer.addGestureRecognizer(tapGesture)

		completeButton.tapped = { [weak self] in
			guard let self = self else { return }
			self.delegate?.completeTapped(cell: self)
		}
	}

	private func setupActionsContainer() {
		let editButton = Button(title: "edit".loc, image: nil)
		editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
		actionsContainer.addArrangedSubview(editButton)

		subtasksButton.addTarget(self, action: #selector(subtasksTapped), for: .touchUpInside)
		actionsContainer.addArrangedSubview(subtasksButton)

		let separator = Separator()
		separator.axis = .vertical
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

			stackContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: Margin.standart),
			stackContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor,
											   constant: Margin.standart),
			stackContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor,
												constant: Margin.standart).reversed,
			stackContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor,
											  constant: Margin.standart).reversed
		])
	}

	private func addPlusCounterHandler() {
		let view = progressViewQueue.view(at: 0)

		view.plusHandler = { [weak self] in
			guard let self = self else { return }
			self.delegate?.plusTapped(cell: self)
		}
	}

	@objc private func editTapped() {
		delegate?.editTapped(cell: self)
	}

	@objc private func subtasksTapped() {
		delegate?.subtasksOpenTapped(cell: self)
	}
}
