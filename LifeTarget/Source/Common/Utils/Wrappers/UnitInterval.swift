//
//  UnitInterval.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

@propertyWrapper
struct UnitInterval<Value: FloatingPoint> {
	@Clamping(0...1)
	var wrappedValue: Value = .zero

	init(wrappedValue: Value) {
		self.wrappedValue = wrappedValue
	}
}
