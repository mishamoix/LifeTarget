//
//  Separator.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import UIKit

final class Separator: UIView {
	enum Axis {
		case vertical
		case horizontal
	}

	enum Insets {
		case none
		case oneSide(CGFloat)
		case bothSide(CGFloat)
	}

	var color: UIColor = Colors.separator {
		didSet {
			updateSeparator()
		}
	}

	var axis: Axis = .horizontal {
		didSet {
			updateSeparator()
		}
	}

	var insets: Insets = .none {
		didSet {
			updateSeparator()
		}
	}

	private let separatorLayer = CALayer()

	override var intrinsicContentSize: CGSize {
		let width = ScreenSizeMapper.value(small: 0.5, other: 1)
		switch axis {
			case .horizontal:
				return CGSize(width: 10, height: width)
			case .vertical:
				return CGSize(width: width, height: 10)
		}
	}

	convenience init(color: UIColor = Colors.background, axis: Axis = .horizontal, insets: Insets = .none) {
		self.init(frame: .zero)
		self.color = color
		self.axis = axis
		self.insets = insets
	}

	override init(frame: CGRect) {
		super.init(frame: .zero)
		setup()
	}

	convenience init() {
		self.init(frame: .zero)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func layoutSubviews() {
		super.layoutSubviews()

		let firstSideInset, secondSideInset: CGFloat
		switch insets {
			case .none:
				firstSideInset = 0
				secondSideInset = 0
			case .oneSide(let inset):
				firstSideInset = inset
				secondSideInset = 0
			case .bothSide(let inset):
				firstSideInset = inset
				secondSideInset = inset
		}

		switch axis {
			case .horizontal:
				separatorLayer.frame = CGRect(x: firstSideInset,
											  y: 0,
											  width: frame.width - firstSideInset - secondSideInset,
											  height: frame.height)
			case .vertical:
				separatorLayer.frame = CGRect(x: 0,
											  y: firstSideInset,
											  width: frame.width,
											  height: frame.height - firstSideInset - secondSideInset)
		}

	}

	private func setup() {
		layer.addSublayer(separatorLayer)
		translatesAutoresizingMaskIntoConstraints = false
	}

	private func updateSeparator() {
		separatorLayer.backgroundColor = color.cgColor
		setNeedsLayout()
	}
}
