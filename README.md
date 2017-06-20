# SKCollectionViewDataSource

![Travis Status](https://travis-ci.org/skladek/SKCollectionViewDataSource.svg?branch=master)
![Codecov Status](https://img.shields.io/codecov/c/github/skladek/SKCollectionViewDataSource.svg)
![Pod Version](https://img.shields.io/cocoapods/v/SKCollectionViewDataSource.svg)
![Platform Status](https://img.shields.io/cocoapods/p/SKCollectionViewDataSource.svg)
![License Status](https://img.shields.io/github/license/skladek/SKCollectionViewDataSource.svg)

SKCollectionViewDataSource provides an object to handle much of the standard UICollectionViewDataSource logic. It handles calculating row and section counts, retrieving cells and supplementary views, and provides methods for updating the underlying array powering the data source. Check out the SampleProject in the workspace to see some usage examples.

---

## Installation

### Cocoapods

Instalation is supported through Cocoapods. Add the following to your pod file for the target where you would like to use SKCollectionViewDataSource:

```
pod 'SKCollectionViewDataSource'
```

---

## Initialization

### Auto Cell Registration

The easiest way to initialize a CollectionViewDataSource object is to provide an array, cell configuration and optionally an array of `SupplementaryViewConfiguration` objects. Cell registration will be handled by the `CollectionViewDataSource` object. The objects array can be a 1 or 2 dimensional array. A single dimension array will display as a single section collection view. A 2 dimensional array will display with multiple sections.

```
import SKCollectionViewDataSource
```

```
let textCellNib = UINib(nibName: "TextCell", bundle: Bundle.main)
let cellConfiguration = CellConfiguration<String>(cell: textCellNib) { (cell, object) in
	// Style the cell with the data object here
}

let dataSource = CollectionViewDataSource(objects: array, cellConfiguration: cellConfiguration)
collectionView.dataSource = dataSource
```

### Manual Cell Registration

If you require access to the cell's reuse identifier or require multiple cell types in your collection view, you can choose to register the cells yourself.


```
import SKCollectionViewDataSource
```
```
collectionView.register(YourCellClass.self, forCellWithReuseIdentifier: "YourReuseIdentifier")
let dataSource = CollectionViewDataSource(objects: array, delegate: self)
tableView.dataSource = dataSource
```
Note: If you choose to handle cell registration on your own, you must implement CollectionViewDataSourceDelegate's `cellForItemAtIndexPath` method and return a cell for each index path.

---

## CellConfiguration

Each auto registering init method requires a CellConfiguration object. This object will inform the CollectionViewDataSource how to configure each cell. The CellConfiguration object can be initialized with a cell class or nib. Additionally, a CellPresenter closure parameter is available. This closure will return with a cell and an object from the objects array. This can be used to populate the cell with values from the returned object.

---

## SupplementaryViewConfiguration

If the collection view contains supplementary views, they can be added and configured with the SupplementaryViewConfiguration object. The object can be initialized with a view class or a nib and a view kind.  Additionally, a SupplementaryViewPresenter closure parameter is available. This closure will return with a view and the section it is to display in. This can be used to configure the view for the section it is displayed within.

---

## CollectionViewDataSourceDelegate

`CollectionViewDataSource` has an optional delegate. This serves as a pass through for `UICollectionViewDataSource` methods. The delegate object can override any of the `CollectionViewDataSource` implementations by implementing the corresponding delegate method.

---

## Updating The Data Array

There are a handful of methods for manipulating the data in the array. Updating the data source will not trigger any sort of update in the table view. That must be handled by the developer.

### delete(indexPath:)
This will delete the object at the provided index path.

### insert(indexPath:)
This will insert the provided object at the provided index path.

### moveFrom(_:to:)
This will move the object at the from index path to the to index path.

### object(indexPath:)
This returns the object at the provided index path.

### setObjects(_:)
This replaces the existing objects array with the provided objects array.