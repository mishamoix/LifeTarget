//
//  Sizes.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

enum Sizes {
	static let smallCornerRadius: CGFloat = ScreenSizeMapper.value(small: 6, other: 8)

	static let cornerRadius: CGFloat = ScreenSizeMapper.value(small: 10, other: 14)

	static let buttonSize: CGFloat = 44

	static let flattenButtonHeight: CGFloat = 30
}
