//
//  CellConfiguration.swift
//  SKCollectionViewDataSource
//
//  Created by Sean on 6/19/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

/// Provides a configuration object for collection view cells.
public struct CellConfiguration<T> {
    let cellClass: UICollectionViewCell.Type?

    let cellNib: UINib?

    let presenter: CollectionViewDataSource<T>.CellPresenter?

    /// The cell's reuse identifier
    public internal(set) var reuseId: String?

    public init(cell: UICollectionViewCell.Type, presenter: CollectionViewDataSource<T>.CellPresenter?) {
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
