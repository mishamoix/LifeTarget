//
//  ViewQueue.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 18.01.2021.
//

import UIKit

final class ViewQueue<T: UIView> {

	private let initializer: () -> T
	private var queue: [T] = []

	init(initializer: @escaping () -> T) {
		self.initializer = initializer
	}

	func view(at index: Int) -> T {
		if queue.count > index {
			return queue[index]
		}

		let newView = initializer()
		queue.append(newView)
		return newView
	}
}
