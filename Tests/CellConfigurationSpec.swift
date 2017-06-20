//
//  CellConfigurationSpec.swift
//  SKCollectionViewDataSource
//
//  Created by Sean on 6/20/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import SKCollectionViewDataSource

class CellConfigurationSpec: QuickSpec {
    override func spec() {
        var presenter: CellConfiguration<String>.Presenter!
        var unitUnderTest: CellConfiguration<String>!

        describe("CellConfiguration") {
            context("init(cell:presenter:)") {
                var cellType: UICollectionViewCell.Type!

                beforeEach {
                    cellType = UICollectionViewCell.self
                    presenter = { (cell, object) in }
                    unitUnderTest = CellConfiguration(cell: cellType, presenter: presenter)
                }

                it("Should set the cell type") {
                    expect(unitUnderTest.cellClass).to(be(cellType))
                }

                it("Should not set the cell nib") {
                    expect(unitUnderTest.cellNib).to(beNil())
                }

                it("Should set the presenter") {
                    expect(unitUnderTest.presenter).to(beAnInstanceOf(CellConfiguration<String>.Presenter.self))
                }
            }

            context("init(cell:presenter:)") {
                var cellNib: UINib!

                beforeEach {
                    cellNib = UINib()
                    presenter = { (cell, object) in }
                    unitUnderTest = CellConfiguration(cell: cellNib, presenter: presenter)
                }

                it("Should set the cell type") {
                    expect(unitUnderTest.cellClass).to(beNil())
                }

                it("Should not set the cell nib") {
                    expect(unitUnderTest.cellNib).to(be(cellNib))
                }

                it("Should set the presenter") {
                    expect(unitUnderTest.presenter).to(beAnInstanceOf(CellConfiguration<String>.Presenter.self))
                }
            }
        }
    }
}
