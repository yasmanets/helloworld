//
//  DateProviderTests.swift
//  hello-worldTests
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import XCTest
@testable import hello_world

class DateProviderTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testTransformDate() throws {
        let testDate = "2022-05-13T09:26:23"
        if let date = DateProvider().transformDate(from: Constants.FULLDATE, to: Constants.DATE, dateToConvert: testDate) {
            XCTAssertTrue(date == "13-05-2022" , "Dates do not match")
        }
        else {
            XCTFail("An error occurred while processing the date")
        }
    }
}
