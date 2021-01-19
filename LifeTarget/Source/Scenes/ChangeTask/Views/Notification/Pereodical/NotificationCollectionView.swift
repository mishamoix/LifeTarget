//
//  NotificationCollectionView.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 19.01.2021.
//

import UIKit

final class NotificationCollectionView: UICollectionView {

	override var contentSize: CGSize {
		get {
			return super.contentSize
		}

		set {
			super.contentSize = newContentSize(with: newValue)
		}
	}

	private func newContentSize(with contentSize: CGSize) -> CGSize {
		let numberOfCells = dataSource?.collectionView(self, numberOfItemsInSection: 0) ?? 0
		let spacing: CGFloat

		if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
			spacing = layout.minimumLineSpacing
		} else {
			spacing = 0
		}

		let newWidth: CGFloat = contentSize.width + CGFloat(max(0, numberOfCells - 1)) * spacing
		return CGSize(width: newWidth, height: contentSize.height)
	}
}
