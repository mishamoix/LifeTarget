//
//  WeekdayModel.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import Foundation

final class WeekdayModel {

	struct Weekday {
		let number: Int
		let name: String
		var isSelected: Bool
	}

	var selected: [Int] {
		return dict.values.filter({ $0.isSelected }).map({ $0.number })
	}

	var hasSelected: Bool {
		return !selected.isEmpty
	}

	var count: Int {
		return dict.count
	}

	private var dict: [Int: Weekday] = {
		let calendar = Calendar.current
		let symbols = calendar.shortWeekdaySymbols

		return symbols
			.enumerated()
			.reduce(into: [Int: Weekday](), { $0[$1.offset] = Weekday(number: $1.offset,
																	  name: $1.element,
																	  isSelected: false) })
	}()

	func toggle(at index: Int) {
		dict[index]?.isSelected.toggle()
	}

	subscript(_ index: Int) -> Weekday? {
		return dict[index]
	}

	func update(index: Int, value: Bool) {
		dict[index]?.isSelected = value
	}

	func reset() {
		dict.keys.forEach({ update(index: $0, value: false) })
	}
}
