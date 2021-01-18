//
//  Numbers+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 13.01.2021.
//

import Foundation

extension Float {
	var nsNumber: NSNumber {
		NSNumber(value: self)
	}

	var int: Int {
		return Int(self)
	}
}

extension Double {
	var nsNumber: NSNumber {
		NSNumber(value: self)
	}
}

extension Int {
	var nsNumber: NSNumber {
		NSNumber(value: self)
	}

	var float: Float {
		return Float(self)
	}
}
