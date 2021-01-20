//
//  NotificationWeekdayCell.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

final class NotificationWeekdayCell: UICollectionViewCell {

	private let weekdayLabel: UILabel = {
		let view = UILabel()
		view.font = Fonts.text
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		contentView.layer.cornerRadius = Sizes.cornerRadius
		contentView.addSubview(weekdayLabel)
		weekdayLabel.isUserInteractionEnabled = false

		NSLayoutConstraint.activate([
			weekdayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margin.small),
			weekdayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margin.standart),
			weekdayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
												   constant: Margin.standart).reversed,
			weekdayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Margin.small).reversed
		])
	}

	func update(with model: WeekdayModel.Weekday) {
		weekdayLabel.text = model.name

		contentView.backgroundColor = model.isSelected ? Colors.accent : Colors.background
		weekdayLabel.textColor = model.isSelected ? UIColor.white : Colors.label
	}
}
