//
//  StorageRaw.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import Foundation

@propertyWrapper
struct StorageRaw<T: RawRepresentable> {
	private let key: String
	private let defaultValue: T

	init(key: String, defaultValue: T) {
		self.key = key
		self.defaultValue = defaultValue
	}

	var wrappedValue: T {
		get {
			if let object = UserDefaults.standard.object(forKey: key) as? T.RawValue,
			   let result = T(rawValue: object) {
				return result
			}

			return defaultValue
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: key)
		}
	}
}
