//
//  CalmMoneyTests.swift
//  CalmMoneyTests
//
//  Created by Oleg Kubrakov on 3/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import XCTest

class CalmMoneyTests: XCTestCase {
    
	//var model: Model = {return TestModel()}()
	
	var transactions = [Transaction]()
	var currencies = [Currency]()
	var categories = [Category]()
	
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
		//preloadData()
		currencies = [
			Currency(code: "RUB", rate: 100),
			Currency(code: "AUD", rate: 1.5),
			Currency(code: "USD", rate: 1),
		]
		categories = [
			Category(name: "Tea", is_expense: true),
			Category(name: "Health", is_expense: true),
			Category(name: "House", is_expense: true),
			Category(name: "Coffee", is_expense: false)
		]
		transactions = [
			Transaction(amount: -3000, date: "2015-11-01 10:00:00", rate: 100, currency: currencies[0]),
			Transaction(amount: -100, date: "2015-11-30 10:00:00", rate: 1, currency: currencies[2]),
			Transaction(amount: -300, date: "2015-12-01 10:00:00", rate: 1.5, currency: currencies[1]),
			Transaction(amount: 3000, date: "2015-11-18 10:00:00", rate: 1.5, currency: currencies[2]),
			Transaction(amount: 2000, date: "2015-11-18 11:00:00", rate: 2, currency: currencies[2]),
		]
		transactions[0].setCategoryWithUpdate(categories[0])
		transactions[1].setCategoryWithUpdate(categories[1])
		transactions[2].setCategoryWithUpdate(categories[2])
		transactions[3].setCategoryWithUpdate(categories[3])
		transactions[4].setCategoryWithUpdate(categories[3])
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	
	func testMath() {
		XCTAssertEqual(transactions.count, 5)
		XCTAssertEqual(currencies.count, 3)
		let math = Math(
			transactions: transactions,
			homeCurrency: currencies[2],
			currentPeriod: PeriodMonth(
				currentDate: Date().fromString("2015-11-15 10:00:00")!,
				initialDate: Date().fromString("2015-10-15 10:00:00")!
			)
		)
		XCTAssertEqual(math.expenses.count, 3)
		XCTAssertEqual(math.earnings.count, 2)
		XCTAssertEqual(math.earningsTotal, 5000)
		XCTAssertEqual(math.expensesTotal, 330)
		XCTAssertEqual(math.expensesAvg, 11)
		XCTAssertEqual(math.earningsAvg.floor(), 166)
		XCTAssertEqual(math.expensesProjected, 330)
		XCTAssertEqual(math.getMoneyInCurrencyWithHistoryRate(math.expensesMaxTransaction!, currency:currencies[2]).amount.abs(), 200)
		
		XCTAssert(math.expenseCategories.count == 3)
		XCTAssertEqual(math.expenseCategories.first, categories[2])
		XCTAssertEqual(math.expenseCategories.last, categories[0])
		
		XCTAssert(math.earningCategories.count == 1)
		XCTAssertEqual(math.earningCategories.first, categories[3])
	}
	
	func testMoney() {
		let money = transactions[2].getMoney()
		XCTAssertEqual(money.amount, -300)
		XCTAssertEqual(money.amount, money.toCurrency(currencies[1]).amount)
		money.appendSymbol("0")
		XCTAssertEqual(money.amount, -3000)
		money.backspace()
		XCTAssertEqual(money.amount, -300)
	}
	
	
	func testPurchase() {
		UserDefaults.standard.set(false, forKey: "purchase_converter")
		UserDefaults.standard.set(false, forKey: "unlimited_transactions")

		
		XCTAssertFalse(Purchase().isPurchasedConverter())
		XCTAssertFalse(Purchase().isPurchasedUnlimitedTransactions())
		
		Purchase().setPurchased(productId: "com.surfingcathk.calmmoney.unlimited_transactions")
		XCTAssertTrue(Purchase().isPurchasedUnlimitedTransactions())
		
		Purchase().setPurchased(productId: "com.surfingcathk.calmmoney.currency_converter_1m")
		XCTAssertTrue(Purchase().isPurchasedConverter())
		
	}
	
	
	func testDate() {
		XCTAssertNotNil(Date().fromString("2017-01-18 10:00:00"), "date string with hours, mins and secs will produce valida object")
		XCTAssertNil(Date().fromString("2017-01-18"), "date string without hours will produce nil")
		XCTAssertNotNil(Date().fromString("1950-01-18 10:00:00"), "date from the past is valid")
		XCTAssertNotNil(Date().fromString("2050-01-18 10:00:00"), "date from the future is valid")
		XCTAssertTrue(Date().fromString("2050-01-18 10:00:00")?.description.range(of: "2050-01-1") != nil)
	}
	
	
	func testPeriodMonth() {
		var period = PeriodMonth(currentDate: Date().fromString("2017-01-18 10:00:00")!, initialDate: Date().fromString("2016-11-30 10:30:01")!)
		XCTAssertEqual(31, period.getDaysCount())
		XCTAssertTrue(period.getDaysPassed() > 0)
		XCTAssertEqual("20170101", period.startDate.formatToHash())
		XCTAssertEqual("20170201", period.endDate.formatToHash())
		XCTAssertTrue(period.description.range(of: "Jan") != nil)
		
		period = PeriodMonth(currentDate: Date().fromString("2017-12-18 10:00:00")!, initialDate: Date().fromString("2017-12-30 10:30:01")!)
		XCTAssertEqual(31, period.getDaysCount())
		XCTAssertTrue(period.getDaysPassed() < 0)
		XCTAssertEqual("20171201", period.startDate.formatToHash())
		XCTAssertEqual("20180101", period.endDate.formatToHash())
		XCTAssertTrue(period.description.range(of: "De") != nil)

	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
