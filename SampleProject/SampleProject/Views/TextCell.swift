//
//  TextCell.swift
//  CollectionViewDataSource
//
//  Created by Sean on 5/15/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class TextCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 10.0
    }
}
