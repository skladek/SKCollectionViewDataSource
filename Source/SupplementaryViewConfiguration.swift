//
//  SupplementaryViewConfiguration.swift
//  SKCollectionViewDataSource
//
//  Created by Sean on 6/19/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

/// Provides a configuration object for collection view supplementary views.
public struct SupplementaryViewConfiguration<T> {
    let presenter: CollectionViewDataSource<T>.SupplementaryViewPresenter?

    /// The view's reuse id.
    public internal(set) var reuseId: String?

    /// The kind of supplementary view.
    public let viewKind: String

    let viewClass: UIView.Type?

    let viewNib: UINib?

    /// Initializes a supplementary view configuration object.
    ///
    /// - Parameters:
    ///   - reuseId: The view's reuse identifier
    ///   - viewKind: The kind of supplementary view
    ///   - presenter: An optional closure that can be used to inject view styling and further configuration.
    public init(view: UIView.Type, viewKind: String, presenter: CollectionViewDataSource<T>.SupplementaryViewPresenter?) {
        self.presenter = presenter
        self.viewClass = view
        self.viewKind = viewKind
        self.viewNib = nil
    }

    public init(view: UINib, viewKind: String, presenter: CollectionViewDataSource<T>.SupplementaryViewPresenter?) {
        self.presenter = presenter
        self.viewClass = nil
        self.viewKind = viewKind
        self.viewNib = view
    }
}
