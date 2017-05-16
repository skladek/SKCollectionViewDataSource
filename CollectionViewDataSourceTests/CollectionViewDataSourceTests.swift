//
//  CollectionViewDataSourceTests.swift
//  CollectionViewDataSourceTests
//
//  Created by Sean on 5/15/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import CollectionViewDataSource

class CollectionViewDataSourceSpec: QuickSpec {

    let reuseId = "testReuseId"

    override func spec() {
        describe("CollectionViewDataSource") {
            context(")") {
                it("Should pass") {
                    expect(1).to(equal(1))
                }
            }
        }
    }
}
