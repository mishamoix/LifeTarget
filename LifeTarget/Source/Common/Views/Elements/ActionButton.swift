//
//  ActionButton.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import UIKit

final class ActionButton: Button {
	override init(title: String? = nil, image: UIImage? = nil) {
		super.init(title: title, image: image)
		contentEdgeInsets = UIEdgeInsets(horizontal: Margin.standart)
		minimumHeight = Sizes.flattenButtonHeight
		setTitleColor(Colors.label, for: .normal)
		backgroundColor = Colors.lightBackground
		titleLabel?.font = Fonts.button
		layer.cornerRadius = Sizes.smallCornerRadius
		addShadow()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
