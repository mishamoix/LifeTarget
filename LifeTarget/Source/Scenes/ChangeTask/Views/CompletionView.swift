//
//  CompletionView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

final class CompletionView: BaseView {

	private(set) var isCompleted = false

	private let title: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.font = Fonts.text
		view.textColor = Colors.label
		view.numberOfLines = 0
		view.text = "is_completed".loc
		return view
	}()

	private let button: UIButton = {
		let view = Button(title: "⚪️", image: nil)
		return view
	}()

	override init() {
		super.init()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func update(with task: Task) {
		isCompleted = task.isCompleted
		updateButton()
	}

	override func setupUI() {

		layer.cornerRadius = Sizes.cornerRadius

		addSubviews(title, button)
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor, constant: Margin.standart),
			title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Margin.standart).reversed,
			title.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: Margin.standart).reversed,

			button.centerYAnchor.constraint(equalTo: title.centerYAnchor),
			button.trailingAnchor.constraint(equalTo: trailingAnchor),
			button.widthAnchor.constraint(equalToConstant: Sizes.buttonSize),
			button.heightAnchor.constraint(equalToConstant: Sizes.buttonSize)
		])
	}

	@objc private func buttonTapped() {
		isCompleted.toggle()
		updateButton()
	}

	private func updateButton() {
		button.setTitle(isCompleted ? "🔘" : "⚪️", for: .normal)
	}
}
