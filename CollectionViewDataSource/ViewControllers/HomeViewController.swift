//
//  HomeViewController.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/15/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    enum Items: String {
        case singleSection = "Single Section Collection View"
        case multipleSection = "Multiple Section Collection View"
        case reorderable = "Reorderable Collection View"
        case supplementaryViews = "Supplementary Views"
    }

    var dataSource: CollectionViewDataSource<Items>?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let reuseId = "HomeViewControllerReuseId"

        let textCellNib = UINib(nibName: "TextCell", bundle: Bundle.main)
        collectionView.register(textCellNib, forCellWithReuseIdentifier: reuseId)

        let array: [Items] = [
            .singleSection,
            .multipleSection,
            .reorderable,
            .supplementaryViews
        ]

        let cellConfiguration = CellConfiguration<Items>(reuseId: reuseId) { (cell, object) in
            guard let cell = cell as? TextCell else {
                return
            }

            cell.label.text = object.rawValue
        }

        dataSource = CollectionViewDataSource(objects: array, cellConfiguration: cellConfiguration)

        collectionView.dataSource = dataSource
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let object = dataSource?.object(indexPath) else {
            return
        }

        let viewController: UIViewController?

        switch object {
        case .singleSection:
            viewController = SingleSectionViewController()
        case .multipleSection:
            viewController = MultipleSectionViewController()
        case .reorderable:
            viewController = ReorderableViewController()
        case .supplementaryViews:
            viewController = SupplementaryViewsViewController()
        }

        if let viewController = viewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
