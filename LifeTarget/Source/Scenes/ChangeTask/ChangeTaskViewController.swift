//
//  ChangeTaskViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 14.01.2021.
//

import UIKit

protocol ChangeTaskDisplayLogic: AnyObject {

	func show(viewModel: ChangeTaskScene.ViewModel)

	func setup(with model: ChangeTaskScene.SetupViewModel)
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

	private let changeTaskTextMainContainer = ChangeTaskTextMainContainer()

	private lazy var durationPicker = DurationPicker(parent: self)

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
		cancelTapped()
	}

	@objc private func cancelTapped() {
		dismiss(animated: true)
	}

	@objc private func tappedAtScroll() {
		view.endEditing(true)
	}

	private func updateInsests(keyboard height: CGFloat = 0) {
		scrollView.contentInset = UIEdgeInsets(top: Margin.large, left: 0,
											   bottom: height + Margin.large, right: 0)
	}
}

// MARK: - ChangeTaskDisplayLogic
extension ChangeTaskViewController: ChangeTaskDisplayLogic {

	func show(viewModel: ChangeTaskScene.ViewModel) {}

	func setup(with model: ChangeTaskScene.SetupViewModel) {
		self.navigationItem.title = model.title
		self.navigationItem.rightBarButtonItem =
			UIBarButtonItem(title: model.saveButtonString, style: .done, target: self, action: #selector(saveTapped))
		self.navigationItem.leftBarButtonItem =
			UIBarButtonItem(title: model.cancelButtonString, style: .plain, target: self, action: #selector(cancelTapped))
	}
}
