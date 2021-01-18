//
//  TaskProgressView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

final class TaskProgressView: UIView {

	private let progressView: ProgressView = {
		let view = ProgressView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let title: UILabel = {
		let label = UILabel()
		label.textColor = Colors.secondaryLabel
		label.font = Fonts.caption
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	convenience init() {
		self.init(frame: .zero)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	func update(with model: ProgressViewModel) {
		title.text = model.subtitle
		progressView.primaryColor = model.color
		progressView.progress = CGFloat(model.progress)
	}

	private func setupViews() {
		translatesAutoresizingMaskIntoConstraints = false
		addSubviews(progressView, title)
		backgroundColor = .clear
		progressView.backgroundColor = Colors.background

		NSLayoutConstraint.activate([
			progressView.topAnchor.constraint(equalTo: topAnchor),
			progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
			progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
			progressView.heightAnchor.constraint(equalToConstant: 6),

			title.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: Margin.small),
			title.leadingAnchor.constraint(equalTo: leadingAnchor),
			title.trailingAnchor.constraint(equalTo: trailingAnchor),
			title.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
