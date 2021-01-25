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

	static var lightBackground: UIColor {
		UIColor(named: "lightBackground") ?? background
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

	static var placeholder: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.placeholderText
		} else {
			return UIColor(hex: "#3c3c434c")
		}
	}

	static var separator: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.systemFill
		} else {
			return UIColor(hex: "#78788033")
		}
	}

	static var progress: UIColor {
		return UIColor.systemGreen
	}

	static var timeLeft: UIColor {
		return UIColor.systemPink
	}

	static var accent: UIColor {
		if #available(iOS 13.0, *) {
			return UIColor.systemIndigo
		} else {
			return UIColor(hex: "#5856d6ff")
		}
	}

	static var attention: UIColor {
		return UIColor.systemPink
	}
}
