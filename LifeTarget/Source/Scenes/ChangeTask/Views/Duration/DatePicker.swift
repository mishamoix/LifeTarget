//
//  DatePicker.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

final class DatePicker: UIView {

	let picker: UIDatePicker = {
		let view = UIDatePicker()
		view.datePickerMode = .date

		if #available(iOS 13.4, *) {
			view.preferredDatePickerStyle = .wheels
		}
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let doneButton: Button = {
		let view = Button(title: "done".loc, image: nil)
		return view
	}()

	private let cancelButton: Button = {
		let view = Button(title: "cancel".loc, image: nil)
		return view
	}()

	private var resultBlock: ((Date?) -> Void)?

	convenience init() {
		self.init(frame: .zero)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func selectDate(on view: UIView, result: @escaping (Date?) -> Void) {
		resultBlock = result

		removeFromSuperview()
		view.addSubview(self)

		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: view.leadingAnchor),
			trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	private func setupUI() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = Colors.secondaryBackground
		addSubviews(cancelButton, doneButton, picker)

		cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
		doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)

		NSLayoutConstraint.activate([
			cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: Margin.small),
			cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),

			doneButton.topAnchor.constraint(equalTo: topAnchor, constant: Margin.small),
			doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,

			picker.topAnchor.constraint(equalTo: cancelButton.bottomAnchor),
			picker.leadingAnchor.constraint(equalTo: leadingAnchor),
			picker.trailingAnchor.constraint(equalTo: trailingAnchor),
			picker.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		])
	}

	@objc private func doneTapped() {
		removeFromSuperview()
		resultBlock?(picker.date)
	}

	@objc private func cancelTapped() {
		removeFromSuperview()
		resultBlock?(nil)
	}
}
