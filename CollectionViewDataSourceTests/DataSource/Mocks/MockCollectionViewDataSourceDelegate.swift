//
//  MockCollectionViewDataSourceDelegate.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/16/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import UIKit

@testable import CollectionViewDataSource

class MockCollectionViewDataSourceDelegate {
    var canMoveItemCalled = false
    var moveItemCalled = false
    var numberOfItemsCalled = false
    var numberOfSectionsCalled = false
    var shouldReturnCell = false
    var shouldReturnSupplementaryView = false

    let cell = MockCell()
    let supplementaryView = MockSupplementaryView()
}

class MockCell: UICollectionViewCell {}
class MockSupplementaryView: UICollectionReusableView {}

extension MockCollectionViewDataSourceDelegate: CollectionViewDataSourceDelegate {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        canMoveItemCalled = true
        return false
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        return shouldReturnCell ? cell : nil
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItemCalled = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItemsCalled = true
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        return shouldReturnSupplementaryView ? supplementaryView : nil
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSectionsCalled = true
        return 5
    }
}
