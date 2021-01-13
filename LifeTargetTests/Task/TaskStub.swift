//
//  TaskStub.swift
//  LifeTargetTests
//
//  Created by Mikhail Malyshev on 13.01.2021.
//

import Foundation
@testable import LifeTarget

//swiftlint:disable all
enum TaskStub {

	static func rootObject(id: Int) -> Task {
		buildObject(id: rootString(with: id, string: "id"),
					title: rootString(with: id, string: "title"))
	}

	static func buildObject(id: String = UUID().uuidString,
							title: String = randomText) -> Task {
		let p = randomFloat
		let progress = Task.Progress(maxCount: p * 2, current: p)

		let timeInterval = TimeInterval(randomFloat)
		let startDate = Date(timeIntervalSince1970: timeInterval)
		let endDate = Date(timeIntervalSince1970: timeInterval * 2)

		return Task(id: id,
					title: title,
					exposition: randomText, progress: progress, duration: Task.Duration(start: startDate, end: endDate),
					notification: nil, isCompleted: false,
					createDate: Date(), updateDate: Date(), subtasks: nil,
					parent: nil)
	}

	static func rootString(with id: Int, string: String) -> String {
		return "\(id)_root_\(string)"
	}

	private static var randomText: String {
		let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let c = charSet.map { String($0) }
		var s: String = ""
		for _ in (1...50) {
			s.append(c[Int(arc4random()) % c.count])
		}
		return s
	}

	private static var randomInt: Int {
		return Int.random(in: 0..<1000)
	}

	private static var randomFloat: Float {
		return Float.random(in: 0..<1000)
	}

}
