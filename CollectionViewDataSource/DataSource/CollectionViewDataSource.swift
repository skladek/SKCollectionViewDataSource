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
    optional func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool

    @objc
    optional func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell?

    @objc
    optional func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)

    @objc
    optional func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int

    @objc
    optional func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView?

    @objc
    optional func numberOfSections(in collectionView: UICollectionView) -> Int
}

class CollectionViewDataSource<T>: NSObject, UICollectionViewDataSource {

    /// A closure to allow the presenter logic to be injected on init.
    typealias CellPresenter = (_ cell: UICollectionViewCell, _ object: T) -> ()

    typealias ReusableViewPresenter = (_ reusableView: UICollectionReusableView, _ object: T) -> ()

    weak var delegate: CollectionViewDataSourceDelegate?

    var objects: [[T]]

    let reuseId: String

    fileprivate let cellPresenter: CellPresenter?

    fileprivate let reusableViewPresenter: ReusableViewPresenter?

    // MARK: Initializers

    convenience init(objects: [T], cellReuseId: String, cellPresenter: CellPresenter? = nil, reusableViewPresenter: ReusableViewPresenter? = nil) {
        self.init(objects: [objects], cellReuseId: cellReuseId, cellPresenter: cellPresenter)
    }

    init(objects: [[T]], cellReuseId: String, cellPresenter: CellPresenter? = nil, reusableViewPresenter: ReusableViewPresenter? = nil) {
        self.cellPresenter = cellPresenter
        self.objects = objects
        self.reusableViewPresenter = reusableViewPresenter
        self.reuseId = cellReuseId
    }

    // MARK: Public Methods

    /// Moves the object at the source index path to the destination index path.
    ///
    /// - Parameters:
    ///   - sourceIndexPath: The current index path of the object.
    ///   - destinationIndexPath: The index path where the object should be after the move.
    func moveFrom(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = object(sourceIndexPath)
        delete(indexPath: sourceIndexPath)
        insert(object: movedObject, at: destinationIndexPath)
    }

    /// Returns the object at the provided index path.
    ///
    /// - Parameter indexPath: The index path of the object to retrieve.
    /// - Returns: Returns the object at the provided index path.
    func object(_ indexPath: IndexPath) -> T {
        let section = sectionArray(indexPath)

        return section[indexPath.row]
    }

    // MARK: Private Methods

    private func delete(indexPath: IndexPath) {
        var section = sectionArray(indexPath)
        section.remove(at: indexPath.row)
        objects[indexPath.section] = section
    }

    private func insert(object: T, at indexPath: IndexPath) {
        var section = sectionArray(indexPath)
        section.insert(object, at: indexPath.row)
        objects[indexPath.section] = section
    }

    private func sectionArray(_ indexPath: IndexPath) -> [T] {
        return objects[indexPath.section]
    }

    // MARK: UICollectionViewDataSource Methods

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return delegate?.collectionView?(collectionView, canMoveItemAt: indexPath) ?? true
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

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.collectionView?(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = delegate?.collectionView?(collectionView, numberOfItemsInSection: section) {
            return items
        }

        let indexPath = IndexPath(item: 0, section: section)
        let section = sectionArray(indexPath)

        return section.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = delegate?.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) {
            return view
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseId, for: indexPath)

        let object = self.object(indexPath)
        reusableViewPresenter?(view, object)

        return view
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = delegate?.numberOfSections?(in: collectionView) {
            return sections
        }

        return objects.count
    }
}
