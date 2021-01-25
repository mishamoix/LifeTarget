//
//  AppAppearanceView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import UIKit

protocol AppAppearanceViewDelegate: AnyObject {
	func didSelectTheme(_ theme: Theme)
}

final class AppAppearanceView: BaseView {

	weak var delegate: AppAppearanceViewDelegate?

	private let title: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.font = Fonts.caption
		view.textColor = Colors.secondaryLabel
		view.text = "choose_appearance".loc
		return view
	}()

	private let segment: UISegmentedControl = {
		let view = UISegmentedControl()
		view.translatesAutoresizingMaskIntoConstraints = false

		Theme
			.allCases
			.enumerated()
			.forEach({
				view.insertSegment(withTitle: $0.element.rawValue.loc,
								   at: $0.offset, animated: false)
			})

		return view
	}()

	func select(theme: Theme) {
		if let index = Theme.allCases.firstIndex(where: { $0 == theme }) {
			segment.selectedSegmentIndex = index
		}
	}

	override func setupUI() {
		super.setupUI()

		layer.cornerRadius = Sizes.cornerRadius
		addSubviews(title, segment)

		segment.addTarget(self, action: #selector(didSelectSegment), for: .valueChanged)

		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor, constant: Margin.standart),
			title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,

			segment.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Margin.small),
			segment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.standart),
			segment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart).reversed,
			segment.bottomAnchor.constraint(equalTo: bottomAnchor,
											constant: Margin.standart).reversed
		])
	}

	@objc private func didSelectSegment() {
		let newTheme = Theme.allCases[segment.selectedSegmentIndex]
		delegate?.didSelectTheme(newTheme)
	}
}
