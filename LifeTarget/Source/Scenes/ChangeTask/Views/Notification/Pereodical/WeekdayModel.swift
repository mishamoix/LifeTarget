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
		return array.filter({ $0.isSelected }).map({ $0.number })
	}

	var hasSelected: Bool {
		return !selected.isEmpty
	}

	var count: Int {
		return array.count
	}

	private var array: [Weekday] = {
		let calendar = Calendar.current
		let symbols = calendar.shortWeekdaySymbols

		return symbols
			.enumerated()
			.map({ Weekday(number: $0.offset + 1, name: $0.element, isSelected: false) })
	}()

	func toggle(at index: Int) {
		array[index].isSelected.toggle()
	}

	subscript(number number: Int) -> Weekday? {
		return array[realIndexForNumber(number: number)]
	}

	subscript(index index: Int) -> Weekday? {
		return array[index]
	}

	func update(number: Int, value: Bool) {
		array[realIndexForNumber(number: number)].isSelected = value
	}

	func reset() {
		for idx in 0..<count {
			array[idx].isSelected = false
		}
	}

	private func realIndexForNumber(number: Int) -> Int {
		array.firstIndex(where: { $0.number == number }) ?? number
	}
}
