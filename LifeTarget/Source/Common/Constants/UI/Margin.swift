//
//  Margin.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

enum Margin {

	static var small: CGFloat {
		return ScreenSizeMapper.value(small: 6, other: 8)
	}

	static var standart: CGFloat {
		return ScreenSizeMapper.value(small: 12, other: 16)
	}

	static var large: CGFloat {
		return ScreenSizeMapper.value(small: 20, other: 24)
	}
}
