//
//  UIColor+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

extension UIColor {
	public convenience init(hex: String) {
		let red, green, blue, alpha: CGFloat

		if hex.hasPrefix("#") {
			let start = hex.index(hex.startIndex, offsetBy: 1)
			let hexColor = String(hex[start...])

			if hexColor.count == 8 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0

				if scanner.scanHexInt64(&hexNumber) {
					red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					alpha = CGFloat(hexNumber & 0x000000ff) / 255

					self.init(red: red, green: green, blue: blue, alpha: alpha)
					return
				}
			}
		}

		self.init(red: 1, green: 1, blue: 1, alpha: 1)
	}
}
