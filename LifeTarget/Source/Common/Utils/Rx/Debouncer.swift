//
//  Debouncer.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import Foundation

public final class Debouncer {

	private let queue: DispatchQueue = DispatchQueue.main

	private var job: DispatchWorkItem = DispatchWorkItem(block: {})
	private var previousRun: Date = Date.distantPast
	private var maxInterval: TimeInterval

	public init(seconds: TimeInterval) {
		self.maxInterval = seconds
	}

	public func execute(block: @escaping () -> Void) {
		job.cancel()
		job = DispatchWorkItem { [weak self] in
			self?.previousRun = Date()
			block()
		}
		queue.asyncAfter(deadline: .now() + maxInterval, execute: job)
	}

	public func cancel() {
		job.cancel()
	}
}

private extension Date {
	static func timeInteval(from referenceDate: Date) -> TimeInterval {
		return Date().timeIntervalSince(referenceDate)
	}
}
