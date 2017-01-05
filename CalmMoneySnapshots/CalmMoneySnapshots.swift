//
//  CalmMoneySnapshots.swift
//  CalmMoneySnapshots
//
//  Created by Oleg Kubrakov on 12/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import XCTest


class CalmMoneySnapshots: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		let app = XCUIApplication()
		setupSnapshot(app)
		app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	
	func testSnapshots() {
		
		let app = XCUIApplication()
		let addTabButton = app.tabBars.buttons.element(boundBy: 1)
		let insightsTabButton = app.tabBars.buttons.element(boundBy: 0)
		let converterTabButton = app.tabBars.buttons.element(boundBy: 2)
		addTabButton.tap()
		
		let button = app.buttons["1"]
		let button6 = app.buttons["6"]
		button.tap()
		app.buttons["2"].tap()
		
		let button2 = app.buttons["8"]
		button2.tap()
		
		let expenseButton = app.buttons.matching(identifier: "addExpense").element(boundBy: 0)
		expenseButton.tap()
		
		app.collectionViews.cells.element(boundBy: 3).tap()
		
		let button3 = app.buttons["5"]
		button3.tap()
		button2.tap()
		
		let button4 = app.buttons["0"]
		button4.tap()
		
		snapshot("01NumPad")
		
		expenseButton.tap()
		
		snapshot("02Categories")
		
		app.collectionViews.cells.element(boundBy: 4).tap()
		button.tap()
		button2.tap()
		button4.tap()
		button4.tap()
		expenseButton.tap()
		app.collectionViews.cells.element(boundBy: 5).tap()
		
		app.otherElements.matching(identifier: "currencySelector").element(boundBy: 0).tap()
		app.tables.cells.element(boundBy: 0).tap()
		button3.tap()
		
		let button5 = app.buttons["6"]
		button5.tap()
		app.buttons["8"].tap()
		app.buttons["0"].tap()
		expenseButton.tap()
		app.collectionViews.cells.element(boundBy: 0).tap()
		
		app.buttons["3"].tap()
		button5.tap()
		expenseButton.tap()
		app.collectionViews.cells.element(boundBy: 1).tap()
		
		button6.tap()
		app.buttons["5"].tap()
		app.buttons["0"].tap()
		expenseButton.tap()
		app.collectionViews.cells.element(boundBy: 2).tap()
		
		app.otherElements.matching(identifier: "currencySelector").element(boundBy: 0).tap()
		app.tables.cells.element(boundBy: 1).tap()
		
		app.buttons["2"].tap()
		app.buttons["5"].tap()
		app.buttons["0"].tap()
		expenseButton.tap()
		app.collectionViews.cells.element(boundBy: 3).tap()

		app.buttons["4"].tap()
		app.buttons["1"].tap()
		app.buttons["0"].tap()
		expenseButton.tap()
		app.collectionViews.cells.element(boundBy: 4).tap()

		app.buttons["1"].tap()
		app.buttons["2"].tap()
		app.buttons["0"].tap()
		expenseButton.tap()
		app.collectionViews.cells.element(boundBy: 5).tap()
		
		
		insightsTabButton.tap()
		snapshot("03Insights")
		
		app.tables.cells.matching(identifier: "transactionsListCell").element(boundBy: 0).tap()
		snapshot("04Transactions")
		
		app.tables.cells.element(boundBy: 0).tap()
		snapshot("05Edit")
		
		
		/*
		tabBarsQuery.buttons["Converter"].tap()
		
		let tablesQuery2 = app.tables
		let addAnotherCurrencyButton = tablesQuery2.buttons["Add another currency"]
		addAnotherCurrencyButton.tap()
		
		tablesQuery2.staticTexts["Singapore dollars"].tap()
		addAnotherCurrencyButton.tap()
		tablesQuery2.staticTexts["Hong Kong dollars"].tap()
		addAnotherCurrencyButton.tap()
		tablesQuery2.staticTexts["Australian dollars"].tap()
		addAnotherCurrencyButton.tap()
		tablesQuery2.staticTexts["Thai baht"].tap()
		
		let textField = tablesQuery2.cells.containing(.staticText, identifier:"HKD").children(matching: .textField).element
		textField.tap()
		textField.typeText("13888")
		tablesQuery.staticTexts["SGD"].tap()
		snapshot("06Converter")
		*/
	}
	
	/*
    func testExample2() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		let app = XCUIApplication()
		
		let tabBarsQuery = app.tabBars
		tabBarsQuery.buttons["Add"].tap()
		
		let button = app.buttons["1"]
		button.tap()
		
		let button2 = app.buttons["0"]
		button2.tap()
		button2.tap()
		
		let expenseButton = app.buttons["Expense"]
		expenseButton.tap()
		
		let collectionViewsQuery = app.collectionViews
		collectionViewsQuery.staticTexts["Restaurant"].tap()
		app.buttons["4"].tap()
		
		let button3 = app.buttons["5"]
		button3.tap()
		
		let button4 = app.buttons["."]
		button4.tap()
		button3.tap()
		expenseButton.tap()
		collectionViewsQuery.staticTexts["Utilities"].tap()
		button3.tap()
		app.buttons["2"].tap()
		button3.tap()
		button2.tap()
		button2.tap()
		
		snapshot("01NumPad")
		
		expenseButton.tap()
		collectionViewsQuery.staticTexts["House"].tap()
		button3.tap()
		button.tap()
		button4.tap()
		button3.tap()
		expenseButton.tap()
		collectionViewsQuery.staticTexts["Tea"].tap()
		
		app.buttons["2"].tap()
		app.buttons["2"].tap() //twice to make it work
		app.buttons["4"].tap()
		expenseButton.tap()
		collectionViewsQuery.staticTexts["Groceries"].tap()
		
		app.buttons["5"].tap()
		app.buttons["5"].tap()
		app.buttons["2"].tap()
		expenseButton.tap()
		collectionViewsQuery.staticTexts["Transport"].tap()
		
		app.buttons["2"].tap()
		app.buttons["2"].tap()
		button2.tap()
		button2.tap()
		expenseButton.tap()
		app.collectionViews.staticTexts["Sport"].tap()
		
		app.buttons["1"].tap()
		app.buttons["2"].tap()
		app.buttons["8"].tap()
		app.buttons["0"].tap()
		expenseButton.tap()
		snapshot("1.5Categories")
		app.collectionViews.staticTexts["Travel"].tap()
		
		
		
		tabBarsQuery.buttons["Insights"].tap()
		
		var tablesQuery = app.tables
		tablesQuery.cells.containing(.staticText, identifier:"Earnings").element.tap()
		tablesQuery.staticTexts["Transactions"].tap()
		
		snapshot("02Transactions")
		
		app.navigationBars["Calm_Money.TransactionsTableView"].buttons["Insights"].tap()
		
		snapshot("03Insights")
		
		tablesQuery.children(matching: .other)["DETAILS"].tap()
		tabBarsQuery.buttons["Converter"].tap()
		

		app.tabBars.buttons["Converter"].tap()
		
		let tablesQuery2 = app.tables
		let addAnotherCurrencyButton = tablesQuery2.buttons["Add another currency"]
		addAnotherCurrencyButton.tap()
		
		tablesQuery = tablesQuery2
		tablesQuery.staticTexts["Singapore dollars"].tap()
		addAnotherCurrencyButton.tap()
		tablesQuery2.searchFields["Search"].tap()
		app.searchFields["Search"].typeText("hk")
		app.tables["Search results"].staticTexts["Hong Kong dollars"].tap()
		addAnotherCurrencyButton.tap()
		tablesQuery.staticTexts["Australian dollars"].tap()
		addAnotherCurrencyButton.tap()
		tablesQuery.staticTexts["Thai baht"].tap()
		
		let textField = tablesQuery2.cells.containing(.staticText, identifier:"HKD").children(matching: .textField).element
		textField.tap()
		textField.typeText("13888")
		snapshot("04Converter")
    }
	*/
}
