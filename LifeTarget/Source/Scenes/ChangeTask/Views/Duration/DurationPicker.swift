//
//  DurationPicker.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

final class DurationPicker: UIView {

	private enum SelectionType {
		case start
		case finish
	}

	private let container: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.translatesAutoresizingMaskIntoConstraints = false
		view.distribution = .fill
		return view
	}()

	private let startButton: DurationButton = {
		let view = DurationButton()
		view.buttonLabel = "select_date".loc
		view.caption = "start_date".loc
		return view
	}()

	private let finishButton: DurationButton = {
		let view = DurationButton()
		view.buttonLabel = "select_date".loc
		view.caption = "finish_date".loc
		return view
	}()

	private let separator: Separator = {
		let view = Separator()
		view.axis = .vertical
		return view
	}()

	private let removeDateButton = Button(title: nil, image: UIImage.named("trash"))

	private let datePicker = DatePicker()

	private let parentViewController: UIViewController

	private var startDate: Date?
	private var finishDate: Date?

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .medium
		return formatter
	}()

	var duration: ChangeTaskScene.Duration? {
		return ChangeTaskScene.Duration(start: startDate, finish: finishDate)
	}

	init(parent: UIViewController) {
		self.parentViewController = parent
		super.init(frame: .zero)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func update(with task: Task) {
		startDate = task.duration?.start
		finishDate = task.duration?.end

		refreshDates()
	}

	private func setupUI() {
		backgroundColor = Colors.secondaryBackground
		container.backgroundColor = Colors.secondaryBackground
		translatesAutoresizingMaskIntoConstraints = false
		layer.cornerRadius = Sizes.cornerRadius

		removeDateButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)

		addSubview(container)

		container.addArrangedSubview(startButton)
		container.addArrangedSubview(finishButton)
		container.addArrangedSubview(removeDateButton)

		container.addSubview(separator)

		let inset: CGFloat = 10
		removeDateButton.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset,
														bottom: inset, right: inset)

		getsuresSetup()
		constrainsSetup()
		refreshDates()
	}

	private func constrainsSetup() {
		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: topAnchor, constant: Margin.standart),
			container.leadingAnchor.constraint(equalTo: leadingAnchor),
			container.trailingAnchor.constraint(equalTo: trailingAnchor),
			container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Margin.standart).reversed,

			separator.topAnchor.constraint(equalTo: container.topAnchor),
			separator.leadingAnchor.constraint(equalTo: startButton.trailingAnchor),
			separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),

			startButton.widthAnchor.constraint(equalTo: finishButton.widthAnchor),

			removeDateButton.heightAnchor.constraint(equalToConstant: Sizes.buttonSize),
			removeDateButton.widthAnchor.constraint(equalTo: removeDateButton.heightAnchor)
		])
	}

	private func getsuresSetup() {
		startButton.didTapped = { [weak self] in
			self?.selectDate(for: .start)
		}

		finishButton.didTapped = { [weak self] in
			self?.selectDate(for: .finish)
		}
	}

	private func selectDate(for type: SelectionType) {
		parentViewController.view.endEditing(true)

		switch type {
		case .start:
			datePicker.picker.minimumDate = nil
			datePicker.picker.date = startDate ?? Date()
		case .finish:
			let minDate = startDate ?? Date()
			datePicker.picker.minimumDate = minDate

			var monthComponent = DateComponents()
			monthComponent.month = 1

			let resultDate = Calendar.current.date(byAdding: monthComponent, to: minDate)
			datePicker.picker.setDate(finishDate ?? resultDate ?? minDate, animated: false)
		}

		datePicker.selectDate(on: parentViewController.view) { [weak self] date in
			defer { self?.refreshDates() }
			guard let date = date else { return }
			switch type {
			case .start:
				self?.startDate = date
			case .finish:
				self?.finishDate = date
			}

			self?.refreshDates()
		}
	}

	private func refreshDates() {
		if let date = startDate {
			let start = dateFormatter.string(from: date)
			startButton.buttonLabel = start
		} else {
			startButton.buttonLabel = "select_date".loc
		}

		if let date = finishDate {
			let finish = dateFormatter.string(from: date)
			finishButton.buttonLabel = finish
		} else {
			finishButton.buttonLabel = "select_date".loc
		}

		let removeDateButtonHidden = startDate == nil && finishDate == nil

		if removeDateButtonHidden != removeDateButton.isHidden {
			UIView.animate(withDuration: CATransaction.animationDuration()) {
				self.removeDateButton.isHidden = removeDateButtonHidden
			}
		}
	}

	@objc private func removeButtonTapped() {
		if startDate != nil && finishDate != nil {
			let alert = UIAlertController(title: "delete_date".loc, message: "you_want_delete_date".loc, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "delete".loc, style: .destructive,
										  handler: { [weak self] _ in
				self?.deleteDates()
			}))

			alert.addAction(UIAlertAction(title: "cancel".loc, style: .default,
										  handler: { _ in }))
			parentViewController.present(alert, animated: true)
		} else {
			deleteDates()
		}
	}

	private func deleteDates() {
		startDate = nil
		finishDate = nil
		refreshDates()
	}
}
