//
//  CollectionViewDataSourceDelegate.swift
//  SKCollectionViewDataSource
//
//  Created by Sean on 6/19/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

@objc
public protocol CollectionViewDataSourceDelegate {
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
