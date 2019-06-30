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

    func testTableAppearancesForString()
    {
        self.launchTSVCWithCommand(command: "Load Strings")
        sleep(1)
        self.testTableAppearanceForCommand(desiredIdx: 5, desiredCellText: "Six")
        self.discardTSVC()
    }
    
    func testTableAppearancesForNumbers()
    {
        self.launchTSVCWithCommand(command: "Load Numbers")
        sleep(1)
        self.testTableAppearanceForCommand(desiredIdx: 2, desiredCellText: "3")
        self.discardTSVC()
    }
    
    func testTableAppearancesForDictionaries()
    {
        self.launchTSVCWithCommand(command: "Load Dictionaries")
        sleep(1)
        self.testTableAppearanceForCommand(desiredIdx: 4, desiredCellText: "lovelyapple")
        self.discardTSVC()
    }
    
    func testSelectionForStrings()
    {
        sleep(1)
        self.launchTSVCWithCommand(command: "Load Strings")
        self.tapAccessoryAtIndex(idx: 3)
        self.pressSelect()
        sleep(1)
        
        let app = XCUIApplication()
        
        //

        let labelQuery = app.staticTexts["resultLabel"]
        let value = labelQuery.label
        XCTAssertTrue(value.contains("two"))
    }
    
    func discardTSVC()
    {
        let app = XCUIApplication()
   //     let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Cancel")
        
        let navBar = app.navigationBars["My List"]
        
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Cancel")
        let btnQuery = navBar.buttons.containing(predicate)
        
        if btnQuery.count > 0
        {
            let button = btnQuery.element(boundBy: 0)
            button.tap()
        }
    }
    
    func pressSelect()
    {
        let app = XCUIApplication()
        //     let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Cancel")
        
        let navBar = app.navigationBars["My List"]
        
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Select")
        let btnQuery = navBar.buttons.containing(predicate)
        
        if btnQuery.count > 0
        {
            let button = btnQuery.element(boundBy: 0)
            button.tap()
        }
    }
    
    func launchTSVCWithCommand(command: String)
    {
        let app = XCUIApplication()
        let predicate = NSPredicate(format: "label == %@", command)
        
        let btnQuery = app.buttons.containing(predicate)
        if btnQuery.count > 0
        {
            let button = btnQuery.element(boundBy: 0)
            button.tap()
        }
        else
        {
            return
        }
    }
    
    func tapAccessoryAtIndex(idx: Int)
    {
        let app = XCUIApplication()
        let table = app.tables.element
        
        let cell = table.cells.element(boundBy: idx)
        let btnQuery = cell.buttons
        
        if btnQuery.count > 0
        {
            let button = btnQuery.element(boundBy: 0)
            button.tap()
        }
        else
        {
            return
        }
    }
    
    func testTableAppearanceForCommand(desiredIdx: Int, desiredCellText: String)
    {
        let app = XCUIApplication()
        
        let table = app.tables.element
        XCTAssertTrue(table.exists)
        
        
        let cell = table.cells.element(boundBy: desiredIdx)
        XCTAssertTrue(cell.exists)
        
        let cellPredicate = NSPredicate(format: "label CONTAINS[c] %@", desiredCellText)
        let indexedText = cell.staticTexts.element(matching: cellPredicate)
        XCTAssertTrue(indexedText.exists)
    }

}
