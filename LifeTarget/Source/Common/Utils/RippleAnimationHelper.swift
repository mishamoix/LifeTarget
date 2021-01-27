//
//  RippleAnimationHelper.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 27.01.2021.
//

import UIKit

final class RippleAnimationHelper {

	private let startView: UIView
	private let parent: UIView
	private let color: CGColor
	private var waveColor: CGColor { Colors.background.withAlphaComponent(0.01).cgColor }
	private let backgroundColor: UIColor

	private let gradientLayer: CAGradientLayer = {
		let layer = CAGradientLayer()
		layer.type = .radial
		layer.locations = [0.0, 0.0, 0.0]
		return layer
	}()

	private var animation: CAAnimation = {
		let animation = CABasicAnimation(keyPath: "locations")
		animation.fromValue = [-1.0, -0.5, 0]
		animation.toValue = [1.0, 1.5, 2.0]
		animation.duration = 0.8
		animation.isRemovedOnCompletion = false
		animation.fillMode = .backwards
		return animation
	}()

	private lazy var overlay: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = true
		view.backgroundColor = backgroundColor
		view.clipsToBounds = true
		view.layer.cornerRadius = Sizes.cornerRadius
		view.isUserInteractionEnabled = false
		return view
	}()

	init(with view: UIView, parent: UIView,
		 color: UIColor = Colors.progress.withAlphaComponent(0.2), background: UIColor = UIColor.clear) {
		self.startView = view
		self.parent = parent
		self.color = color.cgColor
		self.backgroundColor = background
	}

	func animate() {

		parent.addSubview(overlay)

		overlay.frame = parent.bounds
		gradientLayer.frame = parent.bounds

		overlay.layer.insertSublayer(gradientLayer, at: 0)

		let center = CGPoint(x: startView.frame.width / 2.0, y: startView.frame.height / 2.0)
		let viewPosition = startView.convert(center, to: parent)
		let relativePosition = CGPoint(x: viewPosition.x / parent.frame.width,
									   y: viewPosition.y / parent.frame.height)

		gradientLayer.startPoint = relativePosition

		let finalX: CGFloat = 3.0
		let finalY = overlay.frame.width * finalX / overlay.frame.height
		gradientLayer.endPoint = CGPoint(x: finalX, y: finalY)

		gradientLayer.colors = [waveColor, color, waveColor]
		CATransaction.begin()
		CATransaction.setCompletionBlock { [self] in
			overlay.removeFromSuperview()
			gradientLayer.removeAllAnimations()
			gradientLayer.removeFromSuperlayer()
		}
		gradientLayer.add(animation, forKey: "locations")
		CATransaction.commit()
	}
}
