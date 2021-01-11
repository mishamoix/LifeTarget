//
//  Fonts.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

enum Fonts {

	static let title: UIFont = UIFont.systemFont(ofSize: defaultSize + 2,
												 weight: .semibold)

	static let text: UIFont = UIFont.systemFont(ofSize: defaultSize - 1,
												weight: .regular)

	static let caption: UIFont = UIFont.systemFont(ofSize: defaultSize - 4,
												   weight: .light)

	private static let defaultSize = UIFont.systemFontSize + 2
}
