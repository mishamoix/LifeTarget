//
//  SettingsScene.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 12.01.2021.
//

import UIKit

enum SettingsScene {
	struct NotificationViewModel {
		let status: String
		let statusColor: UIColor
		let buttonText: String?

		var buttonIsHidden: Bool {
			buttonText == nil
		}
	}
}
