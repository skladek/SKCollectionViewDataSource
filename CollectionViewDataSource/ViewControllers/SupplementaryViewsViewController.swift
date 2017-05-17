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

        let reuseId = "SupplementaryViewsViewControllerReuseId"

        let textCellNib = UINib(nibName: "TextCell", bundle: Bundle.main)
        collectionView.register(textCellNib, forCellWithReuseIdentifier: reuseId)

        let array = [["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona"], ["California", "Colorado", "Connecticut"], ["District of Columbia", "Delaware"], ["Florida"], ["Georgia", "Guam"], ["Hawaii"], ["Iowa", "Idaho", "Illinois", "Indiana"], ["Kansas", "Kentucky"], ["Louisiana"], ["Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana"], ["North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York"], ["Ohio", "Oklahoma", "Oregon"], ["Pennsylvania", "Puerto Rico"], ["Rhode Island"], ["South Carolina", "South Dakota"], ["Tennessee", "Texas"], ["Utah"], ["Virginia", "Virgin Islands", "Vermont"], ["Washington", "Wisconsin", "West Virginia", "Wyoming"]]

        dataSource = CollectionViewDataSource(objects: array, cellReuseId: reuseId, cellPresenter: { (cell, object) in
            guard let cell = cell as? TextCell else {
                return
            }

            cell.label.text = object
        })
        
        collectionView.dataSource = dataSource
    }
}

extension SupplementaryViewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
}
