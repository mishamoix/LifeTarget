//
//  KeyboardCatcher.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

typealias KeyboardClosure = (CGFloat, TimeInterval) -> Void

final class KeyboardCatcher {

	var onChangeClosure: KeyboardClosure?

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	init(onChange closure: KeyboardClosure? = nil) {
		onChangeClosure = closure

		setup()
	}

	private func setup() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
											   name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillClose),
											   name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc private func keyboardWillChange(notification: Notification) {
		let height = newSize(from: notification)
		let duartion = animationDuration(from: notification)

		onChangeClosure?(height, duartion)
	}

	@objc private func keyboardWillClose(notification: Notification) {
		onChangeClosure?(0, animationDuration(from: notification))
	}

	private func newSize(from notification: Notification) -> CGFloat {
		(notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
	}

	private func animationDuration(from notification: Notification) -> TimeInterval {
		notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
	}

}
