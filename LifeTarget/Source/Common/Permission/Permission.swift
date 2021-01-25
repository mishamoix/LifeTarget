//
//  Permission.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 25.01.2021.
//

import Foundation

enum Authorized {
	case granted
	case restricted
	case none
}

protocol Permission {
	var status: Authorized { get }
	func requestAccess(_ completion: @escaping (Authorized) -> Void)

	func onChange(for object: AnyObject?, _ completion: @escaping (Authorized) -> Void)
	func refresh()
}
