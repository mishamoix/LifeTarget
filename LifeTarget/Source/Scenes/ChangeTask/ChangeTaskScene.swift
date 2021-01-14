//
//  ChangeTaskScene.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

enum ChangeTaskScene {

	enum Input {
		case adding(parent: Task?)
		case change(task: Task)
	}

	struct Output {}

	struct Model {}

	struct Request {}

	struct Response {}

	struct ViewModel {}

	struct SetupViewModel {
		let title: String
		let saveButtonString: String
		let cancelButtonString: String
	}
}
