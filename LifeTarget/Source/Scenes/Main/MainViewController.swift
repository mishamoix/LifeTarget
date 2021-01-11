//
//  MainViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 01.11.2020.
//

import UIKit

final class MainViewController: UIViewController {

	private let progress = ProgressView()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		view.addSubview(progress)

		progress.primaryColor = .green
		progress.backgroundColor = .lightGray

		progress.progress = 0.1

		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			self.progress.progress = 0.7
//			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//				self.progress.progress = 17
//			}
		}

		progress.frame = CGRect(x: 20, y: 40, width: 250, height: 4)

//		view.backgroundColor = .red
//
//		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//			let db = DatabaseCoordinator(name: "Models")
//			//swiftlint:disable all
//
//			guard let read = db.readContext, let write = db.writeContext else {
//				return
//			}
//
//			write.removeEntries(entity: TestDB.self, predicate: NSPredicate(format: "message = \"Привет 4\""))
//			try? write.save()
//
//			read.entries(entity: TestDB.self).enumerated().forEach { index, model in
//				print(index, ": ", model.message, model.date)
//			}
//
//
//			let model2 = write.entry(entity: TestDB.self)
////			model2?.message = "Привет 6"
//			print(model2?.hasChanges)
//
//			TestDB(message: "при4", context: write)
//
//			try? write.save()
//
//			DispatchQueue.main.async {
//				read.entries(entity: TestDB.self).enumerated().forEach { index, model in
//					print(index, ": ", model.message, model.date)
//				}
//			}
//		}
	}
}
