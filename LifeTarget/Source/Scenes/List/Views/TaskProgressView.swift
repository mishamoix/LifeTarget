//
//  TaskProgressView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 11.01.2021.
//

import UIKit

final class TaskProgressView: UIView {
	
	private enum Consts {
		static let plusSize: CGFloat = 30
	}
	
	var showPlus: Bool = false {
		didSet {
			updatePlusButton()
		}
	}
	
	var plusHandler: ((UIView) -> Void)?
	
	private let progressView: ProgressView = {
		let view = ProgressView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let title: UILabel = {
		let label = UILabel()
		label.textColor = Colors.secondaryLabel
		label.font = Fonts.caption
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let plusButton: UIButton = {
		let button = Button(title: nil, image: UIImage.named("circlePlus"))
		button.semanticContentAttribute = .forceLeftToRight
		return button
	}()
	
	private var trailingProgressAnchor: NSLayoutConstraint?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	convenience init() {
		self.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	func update(with model: ProgressViewModel) {
		title.text = model.subtitle
		progressView.primaryColor = model.color
		progressView.progress = CGFloat(model.progress)
		
		plusButton.tintColor = model.color
		showPlus = model.showPlus
	}
	
	func testPointInside(_ point: CGPoint, view: UIView) -> UIView? {
		let point = view.convert(point, to: plusButton)
		if !plusButton.isHidden && plusButton.bounds.contains(point) {
			return plusButton
		}
		
		return nil
	}
	
	private func setupViews() {
		translatesAutoresizingMaskIntoConstraints = false
		addSubviews(progressView, title, plusButton)
		backgroundColor = .clear
		progressView.backgroundColor = Colors.background
		
		plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		
		let trailing = progressView.trailingAnchor.constraint(equalTo: trailingAnchor)
		trailingProgressAnchor = trailing
		
		NSLayoutConstraint.activate([
			progressView.topAnchor.constraint(equalTo: topAnchor),
			progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
			trailing,
			progressView.heightAnchor.constraint(equalToConstant: 6),
			
			title.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: Margin.small),
			title.leadingAnchor.constraint(equalTo: leadingAnchor),
			title.trailingAnchor.constraint(equalTo: trailingAnchor),
			title.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			plusButton.heightAnchor.constraint(equalToConstant: Consts.plusSize),
			plusButton.widthAnchor.constraint(equalToConstant: Sizes.buttonSize),
			plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margin.standart),
			plusButton.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
		])
	}
	
	private func updatePlusButton() {
		plusButton.isHidden = !showPlus
		trailingProgressAnchor?.constant = showPlus ? -Consts.plusSize : 0
	}
	
	@objc func plusTapped() {
		plusHandler?(plusButton)
	}
}
