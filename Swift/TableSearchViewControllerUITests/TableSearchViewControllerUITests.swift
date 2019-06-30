//
//  TableSearchViewControllerUITests.swift
//  TableSearchViewControllerUITests
//
//  Created by Admin on 6/30/19.
//  Copyright © 2019 iPhoneGameZone. All rights reserved.
//

import XCTest

class TableSearchViewControllerUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        XCUIApplication().terminate()
    }

    func testLoadStringsResults() {
        let app = XCUIApplication()
        sleep(1)
        let searchText = "Load Strings"
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", searchText)
        
        let elementQuery = app.buttons.containing(predicate)
        if elementQuery.count > 0
        {
            let label = elementQuery.element(boundBy: 1)
            label.tap()
        }
        else
        {
            return
        }
       
        
        let table = app.tables.element
        XCTAssertTrue(table.exists)
        
        let cell = table.cells.element(boundBy: 5)
        XCTAssertTrue(cell.exists)
        
        let indexedText = cell.staticTexts["six"]
        XCTAssertTrue(indexedText.exists)
    }

}
