//
//  BaseView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

class BaseView: UIView {
	init() {
		super.init(frame: .zero)
		initialSetup()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		initialSetup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupUI() { }

	private func initialSetup() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = Colors.secondaryBackground

		setupUI()
	}
}
