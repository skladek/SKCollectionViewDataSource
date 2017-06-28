import Foundation
import Nimble
import Quick

@testable import SKCollectionViewDataSource

class SupplementaryViewConfigurationSpec: QuickSpec {
    override func spec() {
        var viewKind: String!
        var presenter: SupplementaryViewConfiguration<String>.Presenter!
        var unitUnderTest: SupplementaryViewConfiguration<String>!

        describe("CellConfiguration") {
            beforeEach {
                viewKind = "TestViewKind"
            }

            context("init(cell:presenter:)") {
                var viewType: UICollectionReusableView.Type!

                beforeEach {
                    viewType = UICollectionReusableView.self
                    presenter = { (cell, object) in }
                    unitUnderTest = SupplementaryViewConfiguration(view: viewType, viewKind: viewKind, presenter: presenter)
                }

                it("Should set the cell type") {
                    expect(unitUnderTest.viewClass).to(be(viewType))
                }

                it("Should not set the cell nib") {
                    expect(unitUnderTest.viewNib).to(beNil())
                }

                it("Should set the presenter") {
                    expect(unitUnderTest.presenter).to(beAnInstanceOf(SupplementaryViewConfiguration<String>.Presenter.self))
                }
            }

            context("init(cell:presenter:)") {
                var viewNib: UINib!

                beforeEach {
                    viewNib = UINib()
                    presenter = { (cell, object) in }
                    unitUnderTest = SupplementaryViewConfiguration(view: viewNib, viewKind: viewKind, presenter: presenter)
                }

                it("Should not set the cell type") {
                    expect(unitUnderTest.viewClass).to(beNil())
                }

                it("Should set the cell nib") {
                    expect(unitUnderTest.viewNib).to(be(viewNib))
                }

                it("Should set the presenter") {
                    expect(unitUnderTest.presenter).to(beAnInstanceOf(SupplementaryViewConfiguration<String>.Presenter.self))
                }
            }
        }
    }
}
