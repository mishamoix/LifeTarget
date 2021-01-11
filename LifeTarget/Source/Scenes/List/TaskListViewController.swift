//
//  TaskListViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

protocol TaskListDisplayLogic: AnyObject {
	func show(viewModel: TaskListScene.ViewModel)
}

final class TaskListViewController: UIViewController {

	typealias Scene = TaskListScene

	private let interactor: TaskListInteractionLogic
	private let tableView = UITableView(frame: .null, style: .plain)

	init(interactor: TaskListInteractionLogic) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		interactor.start()
	}

	private func setup() {
		view.backgroundColor = Colors.background

		setupTableView()
		setupConstraints()
	}

	private func setupTableView() {
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false

		tableView.delegate = self
		tableView.dataSource = self

		tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 60
		tableView.separatorStyle = .none
		tableView.backgroundColor = Colors.background
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

// MARK: - TaskListDisplayLogic
extension TaskListViewController: TaskListDisplayLogic {

	func show(viewModel: TaskListScene.ViewModel) {}
}

extension TaskListViewController: UITableViewDelegate { }

extension TaskListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 100
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath)
	}
}
