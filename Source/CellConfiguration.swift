import Foundation

/// Provides a configuration object for collection view cells.
public struct CellConfiguration<T> {

    // MARK: Class Types

    /// A closure to allow the presenter logic to be injected.
    public typealias Presenter = (_ cell: UICollectionViewCell, _ object: T) -> Void

    // MARK: Public Variables

    /// The cell's reuse identifier
    public internal(set) var reuseId: String?

    // MARK: Internal Variables

    let cellClass: UICollectionViewCell.Type?
    let cellNib: UINib?
    let presenter: Presenter?

    // MARK: Init Methods

    /// Initializes a cell configuration object
    ///
    /// - Parameters:
    ///   - cell: The cell class to use for the cells
    ///   - presenter: An optional closure that can be used to inject cell styling and further configuration.
    public init(cell: UICollectionViewCell.Type, presenter: Presenter?) {
        self.cellClass = cell
        self.cellNib = nil
        self.presenter = presenter
    }

    /// Initializes a cell configuration object.
    ///
    /// - Parameters:
    ///   - cell: The cell nib to use for the cells
    ///   - presenter: An optional closure that can be used to inject cell styling and further configuration.
    public init(cell: UINib, presenter: Presenter?) {
        self.cellClass = nil
        self.cellNib = cell
        self.presenter = presenter
    }
}
