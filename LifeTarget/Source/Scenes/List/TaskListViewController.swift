//
//  TaskListViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

protocol TaskListDisplayLogic: AnyObject {
	func show(viewModel: TaskListScene.ViewModel)
	func showEmptyScreen()
}

final class TaskListViewController: UIViewController {

	typealias Scene = TaskListScene

	private let interactor: TaskListInteractionLogic
	private let tableView = UITableView(frame: .null, style: .plain)

	private var viewModel: Scene.ViewModel?

	private var hasParent: Bool {
		viewModel?.hasParent ?? false
	}

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

		navigationItem.rightBarButtonItem =
			UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTaskTapped))

		setupTableView()
		setupConstraints()
	}

	private func setupTableView() {
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false

		tableView.delegate = self
		tableView.dataSource = self

		tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
		tableView.register(ParentCell.self, forCellReuseIdentifier: ParentCell.identifier)

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 60
		tableView.separatorStyle = .none
		tableView.backgroundColor = Colors.background
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Margin.standart, right: 0)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	@objc private func addNewTaskTapped() {
		interactor.addNewTaskTapped()
	}

	private func parentCell(indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ParentCell.identifier,
												 for: indexPath)
		if let cell = cell as? ParentCell, let task = viewModel?.parent {
			cell.update(with: task)
		}

		return cell
	}
}

// MARK: - TaskListDisplayLogic
extension TaskListViewController: TaskListDisplayLogic {

	func show(viewModel: Scene.ViewModel) {
		self.viewModel = viewModel
		tableView.reloadData()
	}

	func showEmptyScreen() {

	}
}

extension TaskListViewController: UITableViewDelegate { }

extension TaskListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (viewModel?.tasks.count ?? 0) + (hasParent ? 1 : 0)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if hasParent && indexPath.row == 0 {
			return parentCell(indexPath: indexPath)
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath)

		let index = hasParent ? indexPath.row - 1 : indexPath.row
		if let cell = cell as? TaskCell, let task = viewModel?.tasks[index] {
			cell.delegate = self
			cell.update(with: task)
		}

		return cell
	}
}

extension TaskListViewController: TaskCellDelegate {
	func editTapped(cell: TaskCell) {
		if let index = tableView.indexPath(for: cell)?.row,
		   let task = viewModel?.tasks[index].task {
			interactor.editTaskTapped(task: task)
		}
	}

	func subtasksOpenTapped(cell: TaskCell) {
		if let index = tableView.indexPath(for: cell)?.row,
		   let task = viewModel?.tasks[index].task {
			interactor.subtasksTapped(task: task)
		}
	}

	func plusTapped(cell: TaskCell) {
		if let index = tableView.indexPath(for: cell)?.row,
		   let task = viewModel?.tasks[index].task {
			interactor.plusTapped(task: task)
		}
	}
}
