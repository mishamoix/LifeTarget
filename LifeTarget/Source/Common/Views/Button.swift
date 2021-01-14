//
//  Button.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import UIKit

final class Button: UIButton {
	init(title: String?, image: UIImage?) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false

		setTitle(title, for: .normal)
		setImage(image, for: .normal)

		tintColor = Colors.accent
		setTitleColor(Colors.accent, for: .normal)
		titleLabel?.font = Fonts.button
		semanticContentAttribute = .forceRightToLeft

		let imageInset: CGFloat = 4
		imageView?.contentMode = .scaleAspectFit
		imageEdgeInsets = UIEdgeInsets(top: imageInset, left: Margin.small, bottom: imageInset, right: 0)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
