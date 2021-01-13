//
//  Date+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 13.01.2021.
//

import Foundation

extension TimeInterval {
	var date: Date {
		return Date(timeIntervalSince1970: self)
	}
}

extension NSDate {
	var date: Date {
		return self as Date
	}
}

extension Date {
	var nsDate: NSDate {
		return self as NSDate
	}
}
