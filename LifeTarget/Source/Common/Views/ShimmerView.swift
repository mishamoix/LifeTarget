//
//  ShimmerView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

final class ShimmerView: UIView {

	var primaryColor: UIColor = Colors.background {
		didSet {
			restartShimmers()
		}
	}

	var waveColor: UIColor = Colors.background {
		didSet {
			restartShimmers()
		}
	}

	private var gradientLayer: CAGradientLayer {
		assert(layer is CAGradientLayer)
		return (layer as? CAGradientLayer) ?? CAGradientLayer()
	}

	private var animation: CAAnimation = {
		let animation = CABasicAnimation(keyPath: "locations")
		animation.fromValue = [-1.0, -0.5, 0]
		animation.toValue = [1.0, 1.5, 2.0]
		animation.duration = 0.5
		animation.isRemovedOnCompletion = false
		animation.fillMode = .forwards

		let group = CAAnimationGroup()
		group.animations = [animation]
		group.repeatCount = .infinity
		group.duration = 4.0
		group.isRemovedOnCompletion = false
		return group
	}()

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

	override class var layerClass: AnyClass {
		return CAGradientLayer.self
	}

	private func setupViews() {
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
		gradientLayer.locations = [0.0, 0.5, 1.0]
		restartShimmers()

	}

	private func restartShimmers() {
		gradientLayer.colors = [primaryColor.cgColor, waveColor.cgColor, primaryColor.cgColor]
		gradientLayer.add(animation, forKey: "locations")
	}
}
