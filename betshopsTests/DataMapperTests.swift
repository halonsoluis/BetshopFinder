//
//  DataMapperTests.swift
//  betshopsTests
//
//  Created by Hugo Alonso on 25/01/2022.
//

import XCTest
@testable import betshops

struct DataMapper {

}

class DataMapperTests: XCTestCase {

    func test_mapper_init() throws {
        let sut = DataMapper()

        XCTAssertNotNil(sut)
    }
}
