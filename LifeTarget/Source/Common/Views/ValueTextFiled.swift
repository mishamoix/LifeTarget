//
//  ValueTextFiled.swift
//  Calculator
//
//  Created by Mikhail Malyshev on 02.08.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import InputMask
import UIKit

final class ValueTextField: UITextField {

	enum InputType {
		case currency
		case int
		case anything
		case custom(String)
	}

	var inputType: InputType = .anything {
		didSet {
			updateSettings()
		}
	}

	var endValue: String?

	var onChange: (() -> Void)?

	private(set) var value: String?

	private let inputMask = MaskedTextFieldDelegate()

	init(type: InputType) {
		super.init(frame: .zero)
		inputType = type
		updateSettings()
	}

	init() {
		super.init(frame: .zero)
		updateSettings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension ValueTextField: MaskedTextFieldDelegateListener {

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		text = value
		delegate?.textField?(self,
							 shouldChangeCharactersIn: NSRange(location: text?.count ?? 0, length: 0),
							 replacementString: "")
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if let text = text, !text.isEmpty {
			self.text = text + " " + (endValue ?? "")
		}
		return true
	}

	func textField(_ textField: UITextField,
				   didFillMandatoryCharacters complete: Bool,
				   didExtractValue value: String) {
		self.value = value
		onChange?()
	}
}

private extension ValueTextField {
	func updateSettings() {
		switch inputType {
		case .currency:
			inputMask.primaryMaskFormat = "[000] [000] [000]"
			inputMask.listener = self
			inputMask.rightToLeft = true
			delegate = inputMask
			keyboardType = .numberPad
		case .int:
			inputMask.primaryMaskFormat = "[00000000]"
			inputMask.listener = self
			inputMask.rightToLeft = true
			delegate = inputMask
			keyboardType = .numberPad
		case .anything:
			delegate = nil
			keyboardType = .default
		case .custom(let pattern):
			inputMask.primaryMaskFormat = pattern
			inputMask.listener = self
			inputMask.rightToLeft = true
			delegate = inputMask
		}
	}
}
