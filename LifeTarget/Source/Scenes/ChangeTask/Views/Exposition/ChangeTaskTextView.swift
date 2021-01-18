//
//  ChangeTaskTextView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

final class ChangeTaskTextView: UITextView {
	var placeholderText: String? {
		didSet {
			refreshPlaceholderIfNeeded()
		}
	}

	var minimumHeight: CGFloat?

	private var isPlaceholderVisible = true

	private var mainFont: UIFont {
		return font ?? Fonts.text
	}

	var realText: String? {
		if isPlaceholderVisible {
			return nil
		}

		return text
	}

	init(placeholder: String? = nil) {
		self.placeholderText = placeholder
		super.init(frame: .zero, textContainer: nil)
		setup()
	}

	@available(*, unavailable)
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		fatalError("init(frame: textContainer:) has not been implemented")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		guard let height = minimumHeight else {
			return size
		}

		return CGSize(width: size.width, height: max(height, size.height))
	}

	private func setup() {
		setupUI()
		setupLogic()
	}

	private func setupUI() {
		backgroundColor = Colors.secondaryBackground
		layer.cornerRadius = Sizes.cornerRadius
		clipsToBounds = true
		isScrollEnabled = false
		translatesAutoresizingMaskIntoConstraints = false
		tintColor = Colors.accent

		refreshTypingAttributes()
		refreshPlaceholderIfNeeded()
	}

	private func setupLogic() {
		delegate = self
	}

	private func refreshTypingAttributes() {
		typingAttributes = [
			NSAttributedString.Key.font: mainFont,
			NSAttributedString.Key.foregroundColor: Colors.label
		]
	}

	private func refreshPlaceholderIfNeeded() {
		if isPlaceholderVisible, let placeholder = placeholderText {
			let attributes: [NSAttributedString.Key: Any] = [
				NSAttributedString.Key.font: mainFont,
				NSAttributedString.Key.foregroundColor: Colors.secondaryLabel
			]

			attributedText = NSAttributedString(string: placeholder, attributes: attributes)
		}
	}

	private func changePlaceholderVisibility(start editing: Bool) {
		if editing && isPlaceholderVisible {
			isPlaceholderVisible = false
			text = nil
		} else if !editing && text.isEmpty {
			isPlaceholderVisible = true
			refreshPlaceholderIfNeeded()
		}

		refreshTypingAttributes()
	}
}

extension ChangeTaskTextView: UITextViewDelegate {
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		changePlaceholderVisibility(start: true)
		return true
	}

	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		changePlaceholderVisibility(start: false)
		return true
	}
}
