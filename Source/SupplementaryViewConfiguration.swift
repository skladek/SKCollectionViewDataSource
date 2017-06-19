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

    // MARK: Public Variables

    /// The view's reuse id.
    public internal(set) var reuseId: String?

    /// The kind of supplementary view.
    public let viewKind: String

    // MARK: Internal Variables

    let presenter: CollectionViewDataSource<T>.SupplementaryViewPresenter?
    let viewClass: UIView.Type?
    let viewNib: UINib?

    // MARK: Init Methods

    /// Initializes a supplementary view configuration object.
    ///
    /// - Parameters:
    ///   - view: The view class that will be used to form the view.
    ///   - viewKind: The view kind that the configuration should be used for.
    ///   - presenter: An optional closure that can be used to inject view styling and further configuration.
    public init(view: UIView.Type, viewKind: String, presenter: CollectionViewDataSource<T>.SupplementaryViewPresenter?) {
        self.presenter = presenter
        self.viewClass = view
        self.viewKind = viewKind
        self.viewNib = nil
    }

    /// Initializes a supplementary view configuration object.
    ///
    /// - Parameters:
    ///   - view: The nib that will be used to form the view.
    ///   - viewKind: The view kind that the configuration should be used for.
    ///   - presenter: An optional closure that can be used to inject view styling and further configuration.
    public init(view: UINib, viewKind: String, presenter: CollectionViewDataSource<T>.SupplementaryViewPresenter?) {
        self.presenter = presenter
        self.viewClass = nil
        self.viewKind = viewKind
        self.viewNib = view
    }
}
