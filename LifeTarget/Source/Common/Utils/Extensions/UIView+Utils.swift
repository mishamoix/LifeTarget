//
//  UIView+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

extension UIView {
	static var identifier: String {
		String(describing: Self.self)
	}

	func addSubviews(_ views: UIView...) {
		views.forEach({ addSubview($0) })
	}

	func addShadow() {
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowRadius = 6
		layer.shadowOpacity = 0.1
		layer.shadowOffset = CGSize(width: 3, height: 3)
	}
}
