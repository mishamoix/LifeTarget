//
//  UIEdgeInsets+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

extension UIEdgeInsets {
	var vertical: CGFloat {
		return top + bottom
	}

	var horizontal: CGFloat {
		return left + right
	}

	init(inset: CGFloat) {
		self.init(top: inset, left: inset, bottom: inset, right: inset)
	}

	init(horizontal: CGFloat) {
		self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
	}

	init(vertical: CGFloat) {
		self.init(top: vertical, left: 0, bottom: vertical, right: 0)
	}
}
