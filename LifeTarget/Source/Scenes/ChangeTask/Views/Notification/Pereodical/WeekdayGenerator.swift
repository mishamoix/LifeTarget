//
//  WeekdayGenerator.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import Foundation

final class WeekdayGenerator {
	static func generate() -> [WeekdayModel] {
		let calendar = Calendar.current
		let symbols = calendar.shortWeekdaySymbols

		return symbols.enumerated().map({ WeekdayModel(name: $0.element, number: $0.offset) })
	}
}
