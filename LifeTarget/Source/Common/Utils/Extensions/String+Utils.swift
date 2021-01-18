//
//  String+Utils.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 15.01.2021.
//

import Foundation

extension String {
	var cleanWhitespace: String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
