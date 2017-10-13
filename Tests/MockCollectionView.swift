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
        // As of iOS 11, this method is being called by the system to register a shadowReuseCell. Ignore that call, we
        // only care if the method is getting called by our data source.
        if identifier == "com.apple.UIKit.shadowReuseCellIdentifier" {
            return
        }

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
