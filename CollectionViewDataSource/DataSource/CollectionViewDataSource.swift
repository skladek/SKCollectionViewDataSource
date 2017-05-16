//
//  CollectionViewDataSource.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/15/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

@objc
protocol CollectionViewDataSourceDelegate {
    @objc
    optional func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell?

    @objc
    optional func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int

    @objc
    optional func numberOfSections(in collectionView: UICollectionView) -> Int
}

class CollectionViewDataSource<T>: NSObject, UICollectionViewDataSource {

    /// A closure to allow the presenter logic to be injected on init.
    typealias CellPresenter = (_ cell: UICollectionViewCell, _ object: T) -> ()

    weak var delegate: CollectionViewDataSourceDelegate?

    let reuseId: String

    let objects: [[T]]

    fileprivate let cellPresenter: CellPresenter?

    convenience init(objects: [T], cellReuseId: String, cellPresenter: CellPresenter? = nil) {
        self.init(objects: [objects], cellReuseId: cellReuseId, cellPresenter: cellPresenter)
    }

    init(objects: [[T]], cellReuseId: String, cellPresenter: CellPresenter? = nil) {
        self.cellPresenter = cellPresenter
        self.objects = objects
        self.reuseId = cellReuseId
    }

    /// Returns the object at the provided index path.
    ///
    /// - Parameter indexPath: The index path of the object to retrieve.
    /// - Returns: Returns the object at the provided index path.
    func object(_ indexPath: IndexPath) -> T {
        let section = sectionArray(indexPath)

        return section[indexPath.row]
    }

    private func sectionArray(_ indexPath: IndexPath) -> [T] {
        return objects[indexPath.section]
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = delegate?.collectionView?(collectionView, cellForItemAt: indexPath) {
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)

        let object = self.object(indexPath)
        cellPresenter?(cell, object)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = delegate?.collectionView?(collectionView, numberOfItemsInSection: section) {
            return items
        }

        let indexPath = IndexPath(item: 0, section: section)
        let section = sectionArray(indexPath)

        return section.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = delegate?.numberOfSections?(in: collectionView) {
            return sections
        }

        return objects.count
    }
}
