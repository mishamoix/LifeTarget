//
//  TaskSorter.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import Foundation

extension Array where Element == Task {
	func sortedTask() -> Self {
		self.sorted(by: { first, second in
			if first.isCompleted == second.isCompleted {
				return first.createDate < second.createDate
			} else {
				if first.isCompleted {
					return false
				} else {
					return true
				}
			}
		})
	}
}
