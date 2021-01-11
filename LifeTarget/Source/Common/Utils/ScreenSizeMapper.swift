//
//  ScreenSizeMapper.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

/// Маппер значений для различных размеров экрана
public final class ScreenSizeMapper {

	private enum ScreenSize {
		case small
		case medium
		case large
	}

	private static let screenSize = ScreenSizeMapper.screenFamily

	/// Возвращает размер экрана
	///
	/// - Note:
	/// Значения взяты из SBFTools
	/// Возможно следует вынести в отдельный класс
	private static var screenFamily: ScreenSize {
		let size = UIScreen.main.bounds.size

		switch size {
			case CGSize(width: 320, height: 480),
				 CGSize(width: 320, height: 568):
				return .small
			case CGSize(width: 375, height: 667),
				 CGSize(width: 414, height: 736):
				return .medium
			default:
				return .large
		}
	}

	/// Возвращает переданное значение в зависимости от размера экрана
	///
	/// - Parameters:
	///   - small: значение для маленьких экранов
	///   - medium: значение для средних экранов
	///   - large: значение для больших экранов
	/// - Returns: значение
	public static func value<T>(small: T, medium: T, large: T) -> T {
		switch screenSize {
			case .small:
				return small
			case .medium:
				return medium
			case .large:
				return large
		}
	}

	/// Возвращает переданное значение в зависимости от размера экрана
	///
	/// - Parameters:
	///   - small: значение для маленьких экранов
	///   - other: значение для остальных экранов
	/// - Returns: значение
	public static func value<T>(small: T, other: T) -> T {
		return value(small: small, medium: other, large: other)
	}
}
