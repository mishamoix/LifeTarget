//
//  UIImage+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import UIKit

extension UIImage {
	static func named(_ name: String) -> UIImage {
		if let image = UIImage(named: name) {
			return image
		}

		assertionFailure("Can't find image \(name)")
		return UIImage()
	}
}
