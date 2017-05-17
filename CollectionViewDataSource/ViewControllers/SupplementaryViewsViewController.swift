//
//  SupplementaryViewsViewController.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/17/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class SupplementaryViewsViewController: UIViewController {

    var dataSource: CollectionViewDataSource<String>?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellConfiguration = CellConfiguration<String>(reuseId: "SupplementaryViewsViewControllerReuseId") { (cell, object) in
            guard let cell = cell as? TextCell else {
                return
            }

            cell.label.text = object
        }

        let reusableViewConfiguration = ReuseableViewConfiguration<String>(reuseId: "ReusableViewReuseId", viewKind: UICollectionElementKindSectionHeader) { (view, section) in
            guard let view = view as? HeaderCell else {
                return
            }

            var firstLetter: String? = nil

            if let firstWord = self.dataSource?.object(IndexPath(item: 0, section: section)) {
                firstLetter = firstWord.substring(to: firstWord.index(firstWord.startIndex, offsetBy: 1))
            }

            view.label.text = firstLetter
        }

        let textCellNib = UINib(nibName: "TextCell", bundle: Bundle.main)
        collectionView.register(textCellNib, forCellWithReuseIdentifier: cellConfiguration.reuseId)

        let reusableViewNib = UINib(nibName: "HeaderCell", bundle: Bundle.main)
        collectionView.register(reusableViewNib, forSupplementaryViewOfKind: reusableViewConfiguration.viewKind, withReuseIdentifier: reusableViewConfiguration.reuseId)

        let array = [["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona"], ["California", "Colorado", "Connecticut"], ["District of Columbia", "Delaware"], ["Florida"], ["Georgia", "Guam"], ["Hawaii"], ["Iowa", "Idaho", "Illinois", "Indiana"], ["Kansas", "Kentucky"], ["Louisiana"], ["Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana"], ["North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York"], ["Ohio", "Oklahoma", "Oregon"], ["Pennsylvania", "Puerto Rico"], ["Rhode Island"], ["South Carolina", "South Dakota"], ["Tennessee", "Texas"], ["Utah"], ["Virginia", "Virgin Islands", "Vermont"], ["Washington", "Wisconsin", "West Virginia", "Wyoming"]]

        dataSource = CollectionViewDataSource(objects: array, cellConfiguration: cellConfiguration, reusableViewConfiguration: reusableViewConfiguration)
        
        collectionView.dataSource = dataSource

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: 100, height: 50)
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
}
