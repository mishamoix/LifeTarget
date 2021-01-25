//
//  ProgressView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

final class ProgressView: UIView {

	@UnitInterval var progress: CGFloat = 0.0 {
		didSet {
			updateScaleViewAnimated()
		}
	}

	var primaryColor: UIColor = .white {
		didSet {
			updateScaleView()
		}
	}

	private let scaleView: ShimmerView = {
		let view = ShimmerView()
		view.clipsToBounds = true
		return view
	}()

	private var cornerRadius: CGFloat {
		return frame.height / 2.0
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	convenience init() {
		self.init(frame: .zero)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		layer.cornerRadius = cornerRadius
		updateScaleView()
	}

	override var intrinsicContentSize: CGSize {
		return CGSize(width: 10, height: 10)
	}

	private func setupViews() {
		addSubview(scaleView)
	}

	private func updateScaleViewAnimated() {
		scaleView.layer.removeAllAnimations()
		UIView.animate(withDuration: CATransaction.animationDuration() * 2) {
			self.updateScaleView()
		}
	}

	private func updateScaleView() {
		scaleView.frame = CGRect(x: 0, y: 0, width: frame.width * progress, height: frame.height)
		scaleView.layer.cornerRadius = cornerRadius
		scaleView.primaryColor = primaryColor
	}
}
