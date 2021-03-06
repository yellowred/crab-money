//
//  CrabAppUITests.swift
//  CrabAppUITests
//
//  Created by Oleg Kubrakov on 2/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import XCTest

class CrabAppUITests: XCTestCase {
	
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
	
	func testAddTransactions() {
		
		let app = XCUIApplication()
		app.tabBars.buttons["Add"].tap()
		app.buttons["1"].tap()
		let button = app.buttons["0"]
		button.tap()
		
		let expenseButton = app.buttons["Expense"]
		expenseButton.tap()
		
		let collectionViewsQuery = app.collectionViews
		collectionViewsQuery.staticTexts["Utilities"].tap()
		
		let button2 = app.buttons["5"]
		button2.tap()
		button2.tap()
		button.tap()
		let amount = app.staticTexts.element(matching: .any, identifier: "50")
		XCTAssert(amount.exists)
		app.buttons["Earning"].tap()
		collectionViewsQuery.staticTexts["Salary"].tap()
		
		XCUIApplication().tabBars.buttons["Insights"].tap()
		let tablesQuery = app.tables
		tablesQuery.staticTexts["Transactions"].tap()
		
		let lastCell = app.tables.cells.element(boundBy: app.tables.cells.count - 1)
		XCTAssertTrue(lastCell.staticTexts["money"].label.contains("50"), "contains instead: \(lastCell.staticTexts["money"].label)")
		
	}
	
	func testDeleteTransactions() {
		
		let tablesQuery = XCUIApplication().tables
		tablesQuery.staticTexts["Transactions"].tap()
		
		tablesQuery.cells.element(boundBy: 0).swipeLeft()
		let beforeCellsCount = tablesQuery.cells.count
		tablesQuery.buttons["Delete"].tap()
		XCTAssertEqual(tablesQuery.cells.count.advanced(by: 1), beforeCellsCount, "before=\(beforeCellsCount), after=\(tablesQuery.cells.count)")
		
	}
	
	func testConverter() {
		XCUIApplication().tabBars.buttons["Converter"].tap()
		
		let app = XCUIApplication()
		app.tabBars.buttons["Converter"].tap()
		
		
		let tablesQuery = app.tables
		let beforeCellsCount = tablesQuery.cells.count
		
		tablesQuery.buttons["Add another currency"].tap()
		tablesQuery.cells.element(boundBy: 0).tap()
		XCTAssertEqual(tablesQuery.cells.count, beforeCellsCount.advanced(by: 1), "before=\(beforeCellsCount), after=\(tablesQuery.cells.count)")

		let textField = tablesQuery.cells.containing(.staticText, identifier:"EUR").children(matching: .textField).element
		textField.tap()
		
		var amount = (tablesQuery.cells.element(boundBy: 0).textFields.element(boundBy: 0).value as! NSString).intValue
		XCTAssertEqual(amount, 0)
		textField.typeText("5")
		textField.typeText("0")
		
		amount = (tablesQuery.cells.element(boundBy: 0).textFields.element(boundBy: 0).value as! NSString).intValue
		XCTAssertTrue(amount > 0)
	}

	
}
