//
//  NotificationDateTimeView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

final class NotificationDateTimeView: BaseView {

	private(set) var currentDate: Date?

	private let button: UIButton = {
		let view = Button(title: "select_date_time".loc, image: nil)
		view.contentHorizontalAlignment = .trailing
		view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
		return view
	}()

	private let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		return formatter
	}()

	private let removeButton = Button(title: nil, image: UIImage.named("trash"))

	private let datePicker: DatePicker = {
		let view = DatePicker()
		view.picker.datePickerMode = .dateAndTime
		return view
	}()

	private let baseView: UIView

	init(baseView: UIView) {
		self.baseView = baseView
		super.init()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setupUI() {

		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)

		updateViews()
		addSubviews(button, removeButton)
		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalTo: topAnchor),
			button.leadingAnchor.constraint(equalTo: leadingAnchor),
			button.bottomAnchor.constraint(equalTo: bottomAnchor),

			removeButton.centerYAnchor.constraint(equalTo: button.centerYAnchor),
			removeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
			removeButton.leadingAnchor.constraint(equalTo: button.trailingAnchor,
												  constant: Margin.standart)
		])
	}

	@objc private func buttonTapped() {
		datePicker.picker.minimumDate = Date()
		datePicker.picker.date = currentDate ?? Date()
		datePicker.selectDate(on: baseView) { [weak self] date in
			self?.currentDate = date ?? self?.currentDate
			self?.updateViews()
		}
	}

	@objc private func removeButtonTapped() {
		currentDate = nil
		updateViews()
	}

	private func updateViews() {
		if let date = currentDate {
			button.setTitle(formatter.string(from: date), for: .normal)
			removeButton.isHidden = false
		} else {
			button.setTitle("select_date_time".loc, for: .normal)
			removeButton.isHidden = true
		}
	}
}
