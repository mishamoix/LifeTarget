//
//  ChangeTaskTextMainContainer.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

final class ChangeTaskTextMainContainer: UIView {
	private let titleTextView: ChangeTaskTextView = {
		let view = ChangeTaskTextView(placeholder: "title_placeholder".loc)
		view.font = Fonts.title
		return view
	}()

	private let expositionTextView: ChangeTaskTextView = {
		let view = ChangeTaskTextView(placeholder: "exposition_placeholder".loc)
		view.font = Fonts.text
		view.minimumHeight = Fonts.text.pointSize * ScreenSizeMapper.value(small: 4, other: 6)
			+ view.textContainerInset.vertical
		return view
	}()

	private let separator: Separator = {
		let view = Separator()
		view.axis = .horizontal
		return view
	}()

	var exposition: ChangeTaskScene.Exposition? {
		guard let title = titleTextView.realText else {
			return nil
		}

		return ChangeTaskScene.Exposition(title: title, subtitle: expositionTextView.realText)
	}

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

	private func setupUI() {
		backgroundColor = Colors.secondaryBackground
		layer.cornerRadius = Sizes.cornerRadius
		translatesAutoresizingMaskIntoConstraints = false
		addSubviews(titleTextView, separator, expositionTextView)

		NSLayoutConstraint.activate([
			titleTextView.topAnchor.constraint(equalTo: topAnchor, constant: Margin.small),
			titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor),

			separator.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
			separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.large - 2),
			separator.trailingAnchor.constraint(equalTo: trailingAnchor),

			expositionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: Margin.small),
			expositionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			expositionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
			expositionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Margin.small).reversed
		])
	}
}
