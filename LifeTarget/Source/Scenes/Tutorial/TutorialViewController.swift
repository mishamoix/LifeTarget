//
//  TutorialViewController.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 26.01.2021.
//

import UIKit

final class TutorialViewController: ViewController {

	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Colors.secondaryBackground
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.alwaysBounceVertical = false
		view.alwaysBounceHorizontal = true
		view.isPagingEnabled = true
		return view
	}()

	private let pageIndicator: UIPageControl = {
		let view = UIPageControl()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.pageIndicatorTintColor = Colors.separator
		view.currentPageIndicatorTintColor = Colors.accent
		view.isUserInteractionEnabled = false
		view.currentPage = 0
		return view
	}()

	private let closeButton = ActionButton(title: "close".loc, image: nil)

	private let models: [Tutorial]
	private var views: [TutorialView] = []

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}

	init(models: [Tutorial]) {
		self.models = models
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .fullScreen
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()

		scrollView.contentOffset = CGPoint(x: CGFloat(pageIndicator.currentPage) * scrollView.frame.width,
										   y: 0)
	}

	private func setupUI() {
		view.backgroundColor = Colors.secondaryBackground
		view.addSubviews(scrollView, pageIndicator, closeButton)

		closeButton.addTarget(self, action: #selector(closeDidTapped), for: .touchUpInside)

		scrollView.delegate = self

		NSLayoutConstraint.activate([
			pageIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
												  constant: Margin.standart).reversed,
			pageIndicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),

			closeButton.centerYAnchor.constraint(equalTo: pageIndicator.centerYAnchor),
			closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
												  constant: Margin.standart).reversed,

			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: closeButton.topAnchor,
											   constant: Margin.small).reversed
		])

		views = models.map({ model in
			let view = TutorialView()
			view.update(with: model)
			scrollView.addSubview(view)
			return view
		})

		pageIndicator.numberOfPages = models.count
	}

	private func layout() {
		let width = scrollView.frame.width
		let height = scrollView.frame.height

		scrollView.contentSize = CGSize(width: width * CGFloat(models.count), height: height)

		views.enumerated().forEach { (idx, view) in
			let size = view.systemLayoutSizeFitting(CGSize(width: width, height: 0),
													withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
			view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
			view.center = CGPoint(x: CGFloat(idx) * width + width / 2, y: height / 2)
		}
	}

	@objc private func closeDidTapped() {
		dismiss(animated: true, completion: nil)
	}
}

extension TutorialViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset.x
		let width = scrollView.frame.width
		let idx: Int

		if offset == 0 {
			idx = 0
		} else {
			idx = Int((offset / width).rounded(.down))
		}

		if idx != pageIndicator.currentPage {
			pageIndicator.currentPage = idx
		}
	}
}
