//
//  DispatchQueue.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import Foundation

extension DispatchQueue {
	static func mainAsyncIfNeeded(_ block: @escaping () -> Void) {
		if Thread.current == Thread.main {
			block()
		} else {
			DispatchQueue.main.async {
				block()
			}
		}
	}
}
