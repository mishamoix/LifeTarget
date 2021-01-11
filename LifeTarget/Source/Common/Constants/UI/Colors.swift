//
//  Colors.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

enum Colors {
	static var background: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.secondarySystemBackground
		} else {
			return UIColor(hex: "#f2f2f7ff")
		}
	}

	static var secondaryBackground: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.systemBackground
		} else {
			return UIColor(hex: "#ffffffff")
		}
	}

	static var label: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.label
		} else {
			return UIColor(hex: "#000000ff")
		}
	}

	static var secondaryLabel: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.secondaryLabel
		} else {
			return UIColor(hex: "#3c3c4399")
		}
	}

	static var progress: UIColor {
		return UIColor.systemGreen
	}

	static var timeLeft: UIColor {
		return UIColor.systemPink
	}
}
