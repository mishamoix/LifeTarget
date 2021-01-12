//
//  Localization.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//
import Foundation

extension String {
	var loc: String {
		return NSLocalizedString(self.lowercased(), comment: "")
	}

	func loc(count: Int) -> String {
		return String.localizedStringWithFormat(self.loc, count)
	}

	static func loc(count: Int, one: String, few: String, many: String, none: String? = nil) -> String {

		if count == 0, let none = none { return none.loc }

		let remainder = count % 10
		let hundredReminder = count % 100

		let fewHundredCondition = 12...14 ~= hundredReminder

		if remainder == 1 && hundredReminder != 11 {
			return one.loc
		} else if 2...4 ~= remainder && !fewHundredCondition {
			return few.loc
		} else if remainder == 0 || 5...9 ~= remainder || 11...14 ~= hundredReminder {
			return many.loc
		}

		assertionFailure("Something wrong with localization for number: \(count)")
		return ""
	}
}
