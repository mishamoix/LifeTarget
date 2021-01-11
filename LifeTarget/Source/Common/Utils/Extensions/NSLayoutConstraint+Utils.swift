//
//  NSLayoutConstraint+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

extension NSLayoutConstraint {
	var reversed: NSLayoutConstraint {
		constant = -constant
		return self
	}
}
