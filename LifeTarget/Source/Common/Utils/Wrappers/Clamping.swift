//
//  Clamping.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

@propertyWrapper
public struct Clamping<Value: Comparable> {
	var value: Value
	let range: ClosedRange<Value>

	public init(wrappedValue: Value, _ range: ClosedRange<Value>) {
		self.range = range
		self.value = range.clamp(wrappedValue)
	}

	public var wrappedValue: Value {
		get { value }
		set { value = range.clamp(newValue) }
	}
}

fileprivate extension ClosedRange {
	func clamp(_ value: Bound) -> Bound {
		return self.lowerBound > value ? self.lowerBound
			: self.upperBound < value ? self.upperBound
			: value
	}
}
