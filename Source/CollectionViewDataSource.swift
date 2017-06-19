//
//  CollectionViewDataSource.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/15/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

/// Provides a configuration object for collection view cells.
public struct CellConfiguration<T> {
    let cellClass: UITableViewCell.Type?

    let cellNib: UINib?

    let presenter: CollectionViewDataSource<T>.CellPresenter?

    /// The cell's reuse identifier
    public fileprivate(set) var reuseId: String?

    public init(cell: UITableViewCell.Type, presenter: CollectionViewDataSource<T>.CellPresenter?) {
        self.cellClass = cell
        self.cellNib = nil
        self.presenter = presenter
    }

    /// Initializes a cell configuration object.
    ///
    /// - Parameters:
    ///   - reuseId: The cell's reuse identifier
    ///   - presenter: An optional closure that can be used to inject cell styling and further configuration.
    public init(cell: UINib, presenter: CollectionViewDataSource<T>.CellPresenter?) {
        self.cellClass = nil
        self.cellNib = cell
        self.presenter = presenter
    }
}

/// Provides a configuration object for collection view supplementary views.
public struct SupplementaryViewConfiguration<T> {
    let presenter: CollectionViewDataSource<T>.SupplementaryViewPresenter?

    /// The view's reuse id.
    public let reuseId: String

    /// The kind of supplementary view.
    public let viewKind: String

    /// Initializes a supplementary view configuration object.
    ///
    /// - Parameters:
    ///   - reuseId: The view's reuse identifier
    ///   - viewKind: The kind of supplementary view
    ///   - presenter: An optional closure that can be used to inject view styling and further configuration.
    public init(reuseId: String, viewKind: String, presenter: CollectionViewDataSource<T>.SupplementaryViewPresenter?) {
        self.presenter = presenter
        self.reuseId = reuseId
        self.viewKind = viewKind
    }
}

public class CollectionViewDataSource<T>: NSObject, UICollectionViewDataSource {

    // MARK: Class Types

    /// A closure to allow the presenter logic to be injected.
    public typealias CellPresenter = (_ cell: UICollectionViewCell, _ object: T) -> Void

    /// A closure to allow the presenter logic to be injected.
    public typealias SupplementaryViewPresenter = (_ reusableView: UICollectionReusableView, _ section: Int) -> Void

    // MARK: Public Variables

    /// The object that acts as the delegate to the data source.
    public weak var delegate: CollectionViewDataSourceDelegate?

    /// The object controlling the configuration of cells.
    public var cellConfiguration: CellConfiguration<T>

    /// An array of objects controlling the configuration of supplementary views. Each supplementary view kind should have its own configuration object.
    public let supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>]

    // MARK: Internal Variables

    var objects: [[T]]

    // MARK: Initializers

    /// Initializes a data source with an array of objects.
    ///
    /// - Parameters:
    ///   - objects: The objects array to display. This is a 1 dimensional array representing a single section table view.
    ///   - cellConfiguration: The cell configuration object to control loading and configuration of cells.
    ///   - supplementaryViewConfigurations: An array of supplementary view objects. Each supplementary view kind should have a configuration object in this array.
    public convenience init(objects: [T], cellConfiguration: CellConfiguration<T>, supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>] = []) {
        self.init(objects: [objects], cellConfiguration: cellConfiguration, supplementaryViewConfigurations: supplementaryViewConfigurations)
    }

    /// Initializes a data source with an array of objects.
    ///
    /// - Parameters:
    ///   - objects: The objects array to display.
    ///   - cellConfiguration: The cell configuration object to control loading and configuration of cells.
    ///   - supplementaryViewConfigurations: An array of supplementary view objects. Each supplementary view kind should have a configuration object in this array.
    public init(objects: [[T]], cellConfiguration: CellConfiguration<T>, supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>] = []) {
        self.cellConfiguration = cellConfiguration
        self.objects = objects
        self.supplementaryViewConfigurations = supplementaryViewConfigurations
    }

    // MARK: Public Methods

    /// Moves the object at the source index path to the destination index path.
    ///
    /// - Parameters:
    ///   - sourceIndexPath: The current index path of the object.
    ///   - destinationIndexPath: The index path where the object should be after the move.
    public func moveFrom(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = object(sourceIndexPath)
        delete(indexPath: sourceIndexPath)
        insert(object: movedObject, at: destinationIndexPath)
    }

    /// Returns the object at the provided index path.
    ///
    /// - Parameter indexPath: The index path of the object to retrieve.
    /// - Returns: Returns the object at the provided index path.
    public func object(_ indexPath: IndexPath) -> T {
        let section = sectionArray(indexPath)

        return section[indexPath.row]
    }

    /// Returns a configuration matching the specified kind string.
    ///
    /// - Parameter kind: The kind string to match against. This should be provided by the collection view.
    /// - Returns: The configuration matching the kind or nil if there is no match.
    public func supplementaryViewConfigurationMatchingKind(_ kind: String) -> SupplementaryViewConfiguration<T>? {
        for configuration in supplementaryViewConfigurations where kind == configuration.viewKind {
            return configuration
        }

        return nil
    }

    // MARK: Internal Methods

    func configureSupplementaryView(_ view: UICollectionReusableView, with configuration: SupplementaryViewConfiguration<T>, at indexPath: IndexPath) {
        configuration.presenter?(view, indexPath.section)
    }

    func registerCellIfNeeded(collectionView: UICollectionView) -> String {
        if let reuseId = cellConfiguration.reuseId {
            return reuseId
        }

        let generatedReuseId = UUID().uuidString

        if let cellNib = cellConfiguration.cellNib {
            collectionView.register(cellNib, forCellWithReuseIdentifier: generatedReuseId)
        } else if let cellClass = cellConfiguration.cellClass {
            collectionView.register(cellClass, forCellWithReuseIdentifier: generatedReuseId)
        } else {
            let exception = NSException(name: .internalInconsistencyException, reason: "A cell could not be registered because a nib or class was not provided and the CollectionViewDataSource delegate cellForRowAtIndexPath method did not return a cell. Provide a nib, class, or cell from the delegate method.", userInfo: nil)
            exception.raise()
        }

        cellConfiguration.reuseId = generatedReuseId

        return generatedReuseId
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

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return delegate?.collectionView?(collectionView, canMoveItemAt: indexPath) ?? true
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = delegate?.collectionView?(collectionView, cellForItemAt: indexPath) {
            return cell
        }

        let reuseId = registerCellIfNeeded(collectionView: collectionView)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)

        let object = self.object(indexPath)
        cellConfiguration.presenter?(cell, object)

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.collectionView?(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = delegate?.collectionView?(collectionView, numberOfItemsInSection: section) {
            return items
        }

        let indexPath = IndexPath(item: 0, section: section)
        let section = sectionArray(indexPath)

        return section.count
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = delegate?.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) {
            return view
        }

        guard let configuration = supplementaryViewConfigurationMatchingKind(kind) else {
            return UICollectionReusableView()
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: configuration.reuseId, for: indexPath)
        configureSupplementaryView(view, with: configuration, at: indexPath)

        return view
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = delegate?.numberOfSections?(in: collectionView) {
            return sections
        }

        return objects.count
    }
}
