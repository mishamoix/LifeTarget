//
//  NotificationPereodicalTime.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

final class NotificationPereodicalTime: BaseView {

	private(set) var weekdays = WeekdayModel()
	private(set) var currentTime: Date?

	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = Margin.small
		layout.minimumInteritemSpacing = 0.001
		layout.sectionInset = .zero
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		layout.scrollDirection = .horizontal

		let view = NotificationCollectionView(frame: .zero, collectionViewLayout: layout)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.showsHorizontalScrollIndicator = false
		view.showsVerticalScrollIndicator = false
		view.backgroundColor = Colors.secondaryBackground
		view.clipsToBounds = false
		view.alwaysBounceHorizontal = true

		return view
	}()

	private let timeButton: UIButton = {
		let view = Button(title: "select_time".loc, image: nil)
		view.contentHorizontalAlignment = .trailing
		view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
		return view
	}()

	private let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		return formatter
	}()

	private let removeButton: UIButton = {
		let view = Button(title: nil, image: UIImage.named("trash"))
		view.semanticContentAttribute = .forceLeftToRight
		return view
	}()

	private let datePicker: DatePicker = {
		let view = DatePicker()
		view.picker.datePickerMode = .time
		return view
	}()

	private let baseView: UIView
	private weak var delegate: NotificationSubviewDelegate?

	init(baseView: UIView, delegate: NotificationSubviewDelegate) {
		self.baseView = baseView
		super.init()
		self.delegate = delegate
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func nullify() {
		currentTime = nil
		weekdays.reset()
		refreshViews()
	}

	func update(with notification: PushNotification) {
		currentTime = notification.dayTime?.date
		notification.weekdays?.forEach({ weekdays.update(index: $0, value: true) })
		refreshViews()
	}

	override func setupUI() {
		setupCollectionView()
		addSubviews(collectionView, timeButton, removeButton)

		timeButton.addTarget(self, action: #selector(selectTimeTapped), for: .touchUpInside)
		removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

		setupConstraints()
		refreshViews()
	}

	private func setupCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(NotificationWeekdayCell.self, forCellWithReuseIdentifier: NotificationWeekdayCell.identifier)
	}

	private func setupConstraints() {
		let collectionViewHeight = Fonts.text.pointSize + 2 * Margin.small + 6
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

			timeButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Margin.small),
			timeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
			timeButton.bottomAnchor.constraint(equalTo: bottomAnchor),

			removeButton.leadingAnchor.constraint(equalTo: timeButton.trailingAnchor,
												  constant: Margin.standart),
			removeButton.centerYAnchor.constraint(equalTo: timeButton.centerYAnchor)
		])
	}

	@objc private func selectTimeTapped() {
		datePicker.picker.date = currentTime ?? Date()
		datePicker.selectDate(on: baseView) { [weak self] date in
			self?.currentTime = date ?? self?.currentTime
			if self?.currentTime != nil {
				self?.delegate?.didSelectTime(with: .pereodically)
			}
			self?.refreshViews()
		}
	}

	@objc private func removeTapped() {
		nullify()
	}

	private func refreshViews() {
		collectionView.reloadData()
		if let date = currentTime {
			timeButton.setTitle(formatter.string(from: date), for: .normal)
		} else {
			timeButton.setTitle("select_time".loc, for: .normal)
		}

		refreshDeleteButton()
	}

	private func refreshDeleteButton() {
		let showDeleteButton = currentTime != nil
			|| weekdays.hasSelected

		removeButton.isHidden = !showDeleteButton
	}
}

extension NotificationPereodicalTime: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		return weekdays.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationWeekdayCell.identifier, for: indexPath)

		if let cell = cell as? NotificationWeekdayCell, let item = weekdays[indexPath.item] {
			cell.update(with: item)
		}

		return cell
	}
}

extension NotificationPereodicalTime: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		weekdays.toggle(at: indexPath.item)
		collectionView.reloadData()
		refreshDeleteButton()
		collectionView.deselectItem(at: indexPath, animated: true)

		delegate?.didSelectTime(with: .pereodically)
	}
}
