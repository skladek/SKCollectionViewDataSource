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
            .multipleSection
        ]

        dataSource = CollectionViewDataSource(objects: array, cellReuseId: reuseId) { (cell, object) in
            guard let cell = cell as? TextCell else {
                return
            }

            cell.label.text = object.rawValue
        }

        collectionView.dataSource = dataSource
        collectionView.reloadData()
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
            viewController = UIViewController()
        case .multipleSection:
            viewController = UIViewController()
        }

        if let viewController = viewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
