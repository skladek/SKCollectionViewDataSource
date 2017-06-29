import UIKit

@testable import SKCollectionViewDataSource

class SecondaryMockSupplementaryView: MockSupplementaryView {}

class MockCollectionView: UICollectionView {
    var registerCellClassCalled = false
    var registerCellNibCalled = false
    var registerSupplementaryClassCalled = false
    var registerSupplementaryNibCalled = false

    override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return SecondaryMockSupplementaryView()
    }

    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        registerCellClassCalled = true
    }

    override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        registerCellNibCalled = true
    }

    override func register(_ nib: UINib?, forSupplementaryViewOfKind kind: String, withReuseIdentifier identifier: String) {
        registerSupplementaryNibCalled = true
    }

    override func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        registerSupplementaryClassCalled = true
    }
}
