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

	private let animator = UIViewPropertyAnimator(duration: CATransaction.animationDuration(),
												  curve: .easeInOut)

	private let doneButton: Button = {
		let view = Button(title: "done".loc, image: nil)
		return view
	}()

	private let cancelButton: Button = {
		let view = Button(title: "cancel".loc, image: nil)
		return view
	}()

	private var resultBlock: ((Date?) -> Void)?
	private var externalBottomAnchor: NSLayoutConstraint?

	private let backgroundView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Colors.background.withAlphaComponent(0.7)
		return view
	}()

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
		view.addSubviews(backgroundView, self)

		backgroundView.alpha = 0

		let bottomAnch = bottomAnchor.constraint(equalTo: view.bottomAnchor,
												 constant: 300)
		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: view.leadingAnchor),
			trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bottomAnch,

			backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])

		externalBottomAnchor = bottomAnch

		view.setNeedsLayout()
		view.layoutIfNeeded()

		animator.stopAnimation(false)

		animator.addAnimations {
			bottomAnch.constant = 0
			self.backgroundView.alpha = 1
			view.setNeedsLayout()
			view.layoutIfNeeded()
		}

		animator.startAnimation()
	}

	private func setupUI() {
		animator.isUserInteractionEnabled = false
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
		removeFromView()
		resultBlock?(picker.date)
	}

	@objc private func cancelTapped() {
		removeFromView()
		resultBlock?(nil)
	}

	private func removeFromView() {

		animator.stopAnimation(true)
		animator.addAnimations {
			self.backgroundView.alpha = 0
			self.externalBottomAnchor?.constant = self.frame.height
			self.superview?.setNeedsLayout()
			self.superview?.layoutIfNeeded()
		}

		animator.addCompletion { _ in
			self.removeFromSuperview()
			self.backgroundView.removeFromSuperview()
		}

		animator.startAnimation()
	}
}
