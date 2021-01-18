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
}
