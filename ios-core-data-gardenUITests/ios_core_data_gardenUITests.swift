//
//  ios_core_data_gardenUITests.swift
//  ios-core-data-gardenUITests
//
//  Created by Kahne Raja on 4/1/17.
//  Copyright © 2017 Kahne Raja. All rights reserved.
//

import XCTest

class ios_core_data_gardenUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.navigationBars["ios_core_data_garden.View"].buttons["Add"].tap()
        app.tables.staticTexts["Exercise 1 (0)"].tap()
        app.otherElements.containing(.navigationBar, identifier:"ios_core_data_garden.Details").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.swipeUp()
        app.navigationBars["ios_core_data_garden.Details"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        XCTAssertEqual(app.tables.staticTexts["Exercise 1 (12)"].exists, true)
    }
    
}
