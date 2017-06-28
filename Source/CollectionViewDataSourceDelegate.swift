import Foundation

/// Exposes all of the UICollectionViewDataSource methods to allow overriding default implementations.
@objc
public protocol CollectionViewDataSourceDelegate {
    /// Asks your data source object whether the specified item can be moved to another location in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path of the item that the collection view is trying to move.
    /// - Returns: true if the item is allowed to move or false if it is not. The default value is true.
    @objc
    optional func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool

    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item.
    /// - Returns: A configured cell object.
    @objc
    optional func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell?

    /// Tells your data source object to move the specified item to its new location.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view notifying you of the move.
    ///   - sourceIndexPath: The item’s original index path.
    ///   - destinationIndexPath: The new index path of the item.
    @objc
    optional func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)

    /// Asks your data source object for the number of items in the specified section.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: An index number identifying a section in collectionView. This index value is 0-based.
    /// - Returns: The number of rows in section.
    @objc
    optional func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int

    /// Asks your data source object to provide a supplementary view to display in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - kind: The kind of supplementary view to provide. The value of this string is defined by the layout object that supports the supplementary view.
    ///   - indexPath: The index path that specifies the location of the new supplementary view.
    /// - Returns: A configured supplementary view object.
    @objc
    optional func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView?

    /// Asks your data source object for the number of sections in the collection view.
    ///
    /// - Parameter collectionView: The collection view requesting this information.
    /// - Returns: The number of sections in collectionView.
    @objc
    optional func numberOfSections(in collectionView: UICollectionView) -> Int
}
