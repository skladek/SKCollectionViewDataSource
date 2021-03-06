import UIKit

/// Provides an object to act as a UICollectionViewDataSource.
public class CollectionViewDataSource<T>: NSObject, UICollectionViewDataSource {

    // MARK: Public Variables

    /// The object that acts as the delegate to the data source.
    public weak var delegate: CollectionViewDataSourceDelegate?

    /// The object controlling the configuration of cells.
    public var cellConfiguration: CellConfiguration<T>?

    /// An array of objects controlling the configuration of supplementary views. Each supplementary view kind should have its own configuration object.
    public var supplementaryViewConfigurations: [String: SupplementaryViewConfiguration<T>]

    // MARK: Internal Variables

    var objects: [[T]]

    // MARK: Initializers

    /// Initializes a data source with an array of objects. Note, if this initializer is used, cells must be registered with the colleciton view before display.
    ///
    /// - Parameters:
    ///   - objects: The objects array to display. This is a 1 dimensional array representing a single section collection view.
    ///   - supplementaryViewConfigurations: An array of supplementary view objects. Each supplementary view kind should have a configuration object in this array.
    public convenience init(objects: [T]?, delegate: CollectionViewDataSourceDelegate, supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>] = []) {
        let wrappedObjects = CollectionViewDataSource.wrapObjects(objects)
        self.init(objectsArray: wrappedObjects, cellConfiguration: nil, supplementaryViewConfigurations: supplementaryViewConfigurations)
        self.delegate = delegate
    }

    /// Initializes a data source with an array of objects. Note, if this initializer is used, cells must be registered with the colleciton view before display.
    ///
    /// - Parameters:
    ///   - objects: The objects array to display. This is a 1 dimensional array representing a single section collection view.
    ///   - supplementaryViewConfigurations: An array of supplementary view objects. Each supplementary view kind should have a configuration object in this array.
    public convenience init(objects: [[T]]?, delegate: CollectionViewDataSourceDelegate, supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>] = []) {
        self.init(objectsArray: objects, cellConfiguration: nil, supplementaryViewConfigurations: supplementaryViewConfigurations)
        self.delegate = delegate
    }

    /// Initializes a data source with an array of objects.
    ///
    /// - Parameters:
    ///   - objects: The objects array to display. This is a 1 dimensional array representing a single section collection view.
    ///   - cellConfiguration: The cell configuration object to control loading and configuration of cells.
    ///   - supplementaryViewConfigurations: An array of supplementary view objects. Each supplementary view kind should have a configuration object in this array.
    public convenience init(objects: [T]?, cellConfiguration: CellConfiguration<T>, supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>] = []) {
        let wrappedObjects = CollectionViewDataSource.wrapObjects(objects)
        self.init(objectsArray: wrappedObjects, cellConfiguration: cellConfiguration, supplementaryViewConfigurations: supplementaryViewConfigurations)
    }

    /// Initializes a data source with an array of objects.
    ///
    /// - Parameters:
    ///   - objects: The objects array to display.
    ///   - cellConfiguration: The cell configuration object to control loading and configuration of cells.
    ///   - supplementaryViewConfigurations: An array of supplementary view objects. Each supplementary view kind should have a configuration object in this array.
    public convenience init(objects: [[T]]?, cellConfiguration: CellConfiguration<T>, supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>] = []) {
        self.init(objectsArray: objects, cellConfiguration: cellConfiguration, supplementaryViewConfigurations: supplementaryViewConfigurations)
    }

    init(objectsArray: [[T]]?, cellConfiguration: CellConfiguration<T>?, supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>] = []) {
        self.cellConfiguration = cellConfiguration
        self.objects = objectsArray ?? [[T]]()
        self.supplementaryViewConfigurations = CollectionViewDataSource.supplementaryViewsDictionary(supplementaryViewConfigurations)
    }

    // MARK: Public Methods

    /// Deletes the object at the provided index path.
    ///
    /// - Parameter indexPath: The index path of the object to delete.
    public func delete(indexPath: IndexPath) {
        var section = sectionArray(indexPath)
        section.remove(at: indexPath.row)
        objects[indexPath.section] = section
    }

    /// Inserts the object at the provided index path.
    ///
    /// - Parameters:
    ///   - object: The object to insert.
    ///   - indexPath: The index path where the object should be inserted.
    public func insert(object: T, at indexPath: IndexPath) {
        var section = sectionArray(indexPath)
        section.insert(object, at: indexPath.row)
        objects[indexPath.section] = section
    }

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

    /// Sets the data source objects from a 1 dimensional array.
    ///
    /// - Parameter objects: The array to update the data store objects with.
    public func setObjects(_ objects: [T]?) {
        let wrappedObjects = CollectionViewDataSource.wrapObjects(objects)

        setObjects(wrappedObjects)
    }

    /// Sets the data source objects to the passed in array.
    ///
    /// - Parameter objects: The array to updat the data store objects with.
    public func setObjects(_ objects: [[T]]?) {
        self.objects = objects ?? [[T]]()
    }

    // MARK: Internal Methods

    func configureSupplementaryView(_ view: UICollectionReusableView, with configuration: SupplementaryViewConfiguration<T>, at indexPath: IndexPath) {
        configuration.presenter?(view, indexPath.section)
    }

    func registerCellIfNeeded(collectionView: UICollectionView) -> String {
        if let reuseId = cellConfiguration?.reuseId {
            return reuseId
        }

        let generatedReuseId = UUID().uuidString

        if let cellNib = cellConfiguration?.cellNib {
            collectionView.register(cellNib, forCellWithReuseIdentifier: generatedReuseId)
        } else if let cellClass = cellConfiguration?.cellClass {
            collectionView.register(cellClass, forCellWithReuseIdentifier: generatedReuseId)
        } else {
            let exception = NSException(name: .internalInconsistencyException, reason: "A cell could not be registered because a nib or class was not provided and the CollectionViewDataSource delegate cellForRowAtIndexPath method did not return a cell. Provide a nib, class, or cell from the delegate method.", userInfo: nil)
            exception.raise()
        }

        cellConfiguration?.reuseId = generatedReuseId

        return generatedReuseId
    }

    func registerSupplementaryViewIfNeeded(collectionView: UICollectionView, configuration: SupplementaryViewConfiguration<T>) -> String {
        if let reuseId = configuration.reuseId {
            return reuseId
        }

        let generatedReuseId = UUID().uuidString

        if let viewNib = configuration.viewNib {
            collectionView.register(viewNib, forSupplementaryViewOfKind: configuration.viewKind, withReuseIdentifier: generatedReuseId)
        } else if let viewClass = configuration.viewClass {
            collectionView.register(viewClass, forSupplementaryViewOfKind: configuration.viewKind, withReuseIdentifier: generatedReuseId)
        } else {
            let exception = NSException(name: .internalInconsistencyException, reason: "A supplementary view could not be registered because a nib or class was not provided and the CollectionViewDataSource delegate viewForSupplementaryElementOfKind method did not return a view. Provide a nib, class, or view from the delegate method.", userInfo: nil)
            exception.raise()
        }

        var mutableConfiguration = configuration
        mutableConfiguration.reuseId = generatedReuseId
        supplementaryViewConfigurations[mutableConfiguration.viewKind] = mutableConfiguration

        return generatedReuseId
    }

    // MARK: Internal Static Methods

    static func supplementaryViewsDictionary(_ supplementaryViewConfigurations: [SupplementaryViewConfiguration<T>]) -> [String: SupplementaryViewConfiguration<T>] {
        var dictionary = [String: SupplementaryViewConfiguration<T>]()

        for configuration in supplementaryViewConfigurations {
            if dictionary[configuration.viewKind] != nil {
                let exception = NSException(name: .internalInconsistencyException, reason: "Multiple SupplementaryViewConfigurations were found for view kind \(configuration.viewKind). Only one configuration is supported for each view kind. Use the CollectionViewDataSourceDelegate if more than one configuration is needed.", userInfo: nil)
                exception.raise()
                continue
            }

            dictionary[configuration.viewKind] = configuration
        }

        return dictionary
    }

    static func wrapObjects(_ objects: [T]?) -> [[T]] {
        var wrappedObjects: [[T]]? = nil
        if let objects = objects {
            wrappedObjects = [objects]
        }

        return wrappedObjects ?? [[T]]()
    }

    // MARK: Private Methods

    private func sectionArray(_ indexPath: IndexPath) -> [T] {
        return objects[indexPath.section]
    }

    // MARK: UICollectionViewDataSource Methods

    /// UICollectionViewDataSource implementation.
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return delegate?.collectionView?(collectionView, canMoveItemAt: indexPath) ?? true
    }

    /// UICollectionViewDataSource implementation.
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = delegate?.collectionView?(collectionView, cellForItemAt: indexPath) {
            return cell
        }

        let reuseId = registerCellIfNeeded(collectionView: collectionView)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)

        let object = self.object(indexPath)
        cellConfiguration?.presenter?(cell, object)

        return cell
    }

    /// UICollectionViewDataSource implementation.
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.collectionView?(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }

    /// UICollectionViewDataSource implementation.
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = delegate?.collectionView?(collectionView, numberOfItemsInSection: section) {
            return items
        }

        let indexPath = IndexPath(item: 0, section: section)
        let section = sectionArray(indexPath)

        return section.count
    }

    /// UICollectionViewDataSource implementation.
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = delegate?.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) {
            return view
        }

        guard let configuration = supplementaryViewConfigurations[kind] else {
            let exception = NSException(name: .internalInconsistencyException, reason: "A supplementary view configuration was not found for kind: \(kind). A view must be returned from the delegate viewForSupplementaryElementOfKind method or a configuration must be provided for all supplementary view kinds.", userInfo: nil)
            exception.raise()

            return UICollectionReusableView()
        }

        let reuseId = registerSupplementaryViewIfNeeded(collectionView: collectionView, configuration: configuration)

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseId, for: indexPath)
        configureSupplementaryView(view, with: configuration, at: indexPath)

        return view
    }

    /// UICollectionViewDataSource implementation.
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = delegate?.numberOfSections?(in: collectionView) {
            return sections
        }

        return objects.count
    }
}
