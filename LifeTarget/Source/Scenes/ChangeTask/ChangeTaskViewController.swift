//
//  ChangeTaskViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

protocol ChangeTaskDisplayLogic: AnyObject {

	func setup(with model: ChangeTaskScene.SetupViewModel)
	func show(error: ChangeTaskScene.ErrorModel)
}

final class ChangeTaskViewController: UIViewController {

	typealias Scene = ChangeTaskScene

	private let interactor: ChangeTaskInteractionLogic
	private let keyboardCatcher = KeyboardCatcher()

	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.keyboardDismissMode = .interactive
		return view
	}()

	private let stackContainer: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.translatesAutoresizingMaskIntoConstraints = false
		view.spacing = Margin.standart
		view.alignment = .fill
		return view
	}()

	private lazy var removeButton: UIButton = {
		let button = Button(title: "delete".loc, image: nil)
		button.setTitleColor(Colors.attention, for: .normal)
		button.backgroundColor = Colors.secondaryBackground
		button.layer.cornerRadius = Sizes.cornerRadius
		button.minimumHeight = Sizes.buttonSize
		return button
	}()

	private let changeTaskTextMainContainer = ChangeTaskTextMainContainer()
	private lazy var durationPicker = DurationPicker(parent: self)
	private let progressCounter = ProgressContainer()

	init(interactor: ChangeTaskInteractionLogic) {
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
		scrollView.backgroundColor = Colors.background
		stackContainer.backgroundColor = Colors.background

		view.addSubview(scrollView)
		scrollView.addSubview(stackContainer)

		stackContainer.addArrangedSubview(changeTaskTextMainContainer)
		stackContainer.addArrangedSubview(progressCounter)
		stackContainer.addArrangedSubview(durationPicker)

		setupConstraints()

		self.updateInsests()
		keyboardCatcher.onChangeClosure = { [weak self] height, duartion in
			self?.updateInsests(keyboard: height)
		}

		let tap = UITapGestureRecognizer(target: self, action: #selector(tappedAtScroll))
		scrollView.addGestureRecognizer(tap)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			stackContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
			stackContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Margin.standart),
			stackContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: Margin.standart).reversed,
			stackContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			stackContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Margin.standart)
		])
	}

	@objc private func saveTapped() {
		let model = ChangeTaskScene.Model(duration: durationPicker.duration, progress: progressCounter.progress,
										  exposition: changeTaskTextMainContainer.exposition)
		interactor.saveTapped(with: model, viewController: self)
	}

	private func updateInsests(keyboard height: CGFloat = 0) {
		scrollView.contentInset = UIEdgeInsets(top: Margin.large, left: 0,
											   bottom: height + Margin.large, right: 0)
	}

	private func addRemoveButton() {
		removeButton.addTarget(self, action: #selector(tappedAtRemove), for: .touchUpInside)
		stackContainer.addArrangedSubview(removeButton)
	}

	@objc private func cancelTapped() {
		interactor.closeTapped(viewController: self)
	}

	@objc private func tappedAtScroll() {
		view.endEditing(true)
	}

	@objc private func tappedAtRemove() {
		let alert = UIAlertController(title: "remove_task_title".loc,
									  message: "remove_task_subtitle".loc, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "delete".loc, style: .destructive, handler: { [weak self] _ in
			guard let self = self else { return }
			self.interactor.removeTapped(viewController: self)
		}))

		alert.addAction(UIAlertAction(title: "cancel".loc, style: .default))
		present(alert, animated: true)
	}
}

// MARK: - ChangeTaskDisplayLogic
extension ChangeTaskViewController: ChangeTaskDisplayLogic {

	func setup(with model: ChangeTaskScene.SetupViewModel) {
		self.navigationItem.title = model.title
		self.navigationItem.rightBarButtonItem =
			UIBarButtonItem(title: model.saveButtonString, style: .done, target: self, action: #selector(saveTapped))
		self.navigationItem.leftBarButtonItem =
			UIBarButtonItem(title: model.cancelButtonString, style: .plain, target: self, action: #selector(cancelTapped))

		if let task = model.task {
			changeTaskTextMainContainer.update(with: task)
			progressCounter.update(with: task)
			durationPicker.update(with: task)
		}

		if model.isModify {
			addRemoveButton()
		}
	}

	func show(error: ChangeTaskScene.ErrorModel) {
		let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "ok".loc, style: .default))
		present(alert, animated: true)
	}
}
